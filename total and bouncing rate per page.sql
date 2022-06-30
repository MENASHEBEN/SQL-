
create temporary table table5
select website_session_id,
max(lander_page) as mlander,max(product_page) as mproduct,max(original_page) as moriginal,
max(cart_page) as mcart,max(shipping_page) as mshipping, max(billing_page) as mbilling,max(thank_you_page) as mthank
from
(select website_sessions.website_session_id,
case when website_pageviews.pageview_url='/lander-1' then 1 else 0 end as lander_page,
case when website_pageviews.pageview_url='/products' then 1 else 0 end as product_page,
case when website_pageviews.pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as original_page,
case when website_pageviews.pageview_url='/cart' then 1 else 0 end as cart_page,
case when website_pageviews.pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when website_pageviews.pageview_url='/billing' then 1 else 0 end as billing_page,
case when website_pageviews.pageview_url='/thank-you-for-your-order' then 1 else 0 end as thank_you_page,
website_pageviews.pageview_url 
from website_sessions
left join website_pageviews
on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.utm_source='gsearch' and website_sessions.utm_campaign='nonbrand'
 and website_sessions.created_at between '2012-08-05' and '2012-09-05') as pred
 group by 1 ;

select count(website_session_id) as sessions,
count(distinct case when mlander=1 then website_session_id else null end) as t_lander,
count(distinct case when mproduct=1 then website_session_id else null end) as t_product,
count(distinct case when moriginal=1 then website_session_id else null end) as t_original,
count(distinct case when mcart=1 then website_session_id else null end) as t_cart,
count(distinct case when mshipping=1 then website_session_id else null end) as t_shipping,
count(distinct case when mbilling=1 then website_session_id else null end) as t_billing,
count(distinct case when mthank=1 then website_session_id else null end) as t_thanks
from table5;
 

select count(website_session_id) as sessions,
count(distinct case when mproduct=1 then website_session_id else null end)/count(website_session_id) as pt_product,
count(distinct case when moriginal=1 then website_session_id else null end)/count(distinct case when mproduct=1 then website_session_id else null end) as pt_original,
count(distinct case when mcart=1 then website_session_id else null end)/count(distinct case when moriginal=1 then website_session_id else null end) as pt_cart,
count(distinct case when mshipping=1 then website_session_id else null end)/count(distinct case when mcart=1 then website_session_id else null end) as pt_shipping,
count(distinct case when mbilling=1 then website_session_id else null end)/count(distinct case when mshipping=1 then website_session_id else null end) as pt_billing,
count(distinct case when mthank=1 then website_session_id else null end)/count(distinct case when mbilling=1 then website_session_id else null end) as pt_thanks
from table5;