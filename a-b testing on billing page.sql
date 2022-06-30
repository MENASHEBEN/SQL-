select min(website_session_id)
from website_pageviews
where pageview_url = '/billing-2';

create temporary table t8
select website_session_id,
max(billing_page) as mbilling,max(billing2_page) as mbilling2, max(thank_you_page) as mthanks
from 
(select website_sessions.website_session_id,
case when website_pageviews.pageview_url='/billing' then 1 else 0 end as billing_page,
case when website_pageviews.pageview_url='/billing-2' then 1 else 0 end as billing2_page,
case when website_pageviews.pageview_url='/thank-you-for-your-order' then 1 else 0 end as thank_you_page,
website_pageviews.pageview_url
from website_sessions
left join website_pageviews
on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.website_session_id>=25325 
and website_pageviews.created_at<'2012-11-10') as predd
group by 1;

select* from  t8;

select count(website_session_id) as sessions,
count(distinct case when mbilling=1 then website_session_id else null end) as bil_1,
 count(distinct case when mbilling2=1 then website_session_id else null end) as bil_2,
 count(distinct case when mthanks=1 and mbilling=1 then website_session_id else null end)/count(distinct case when mbilling=1 then website_session_id else null end) as thanks1_rate,
 count(distinct case when mthanks=1 and mbilling2=1 then website_session_id else null end)/count(distinct case when mbilling2=1 then website_session_id else null end) as thanks2_rate
 from t8