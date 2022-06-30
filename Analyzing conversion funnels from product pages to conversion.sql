create temporary table t1
select pageview_url as product_seen, website_session_id,website_pageview_id
 from website_pageviews
where created_at between '2013-01-06'and '2013-04-10'
and pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear');

select distinct pageview_url from website_pageviews where created_at between '2013-01-06'and '2013-04-10';

create temporary table t2
select t1.product_seen,t1.website_session_id,
case when website_pageviews.pageview_url='/cart' then 1 else 0 end as cart,
 case when website_pageviews.pageview_url='/shipping' then 1 else 0 end as shipping,
case when website_pageviews.pageview_url='/billing-2' then 1 else 0 end as billing,
case when website_pageviews.pageview_url='/thank-you-for-your-order' then 1 else 0 end as thanks
from t1
left join website_pageviews
on website_pageviews.website_session_id=t1.website_session_id
and website_pageviews.website_pageview_id>t1.website_pageview_id;

create temporary table t4
select product_seen,website_session_id,max(cart) as cart_page,max(shipping) as ship_page,
max(billing) as billing_page,max(thanks) as thanks_page
from t2 
group by 2 ;

create temporary table results
select t4.product_seen,count(website_session_id) as sessions,
 count(case when cart_page=1 then website_session_id else null end) as cart_seen,
count(case when ship_page=1 then website_session_id else null end) as ship_seen,
count(case when billing_page=1 then website_session_id else null end) as bill_seen,
count(case when thanks_page=1 then website_session_id else null end) as thanks_seen
from t4
group by 1;

select product_seen, cart_seen/sessions as cart_per,
ship_seen/cart_seen as ship_per, bill_seen/ship_seen as bill_per,thanks_seen/bill_seen as thanks_per
from results