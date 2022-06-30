create temporary table t1
select website_sessions.website_session_id,website_pageviews.pageview_url,
website_pageviews.created_at, count(website_pageviews.website_pageview_id) as n_pageviews,
min(website_pageviews.website_pageview_id) as f_pageview_id
from website_sessions
left join website_pageviews
on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.utm_campaign='nonbrand' and website_sessions.utm_source='gsearch'
and website_sessions.created_at between '2012-06-01' and '2012-08-31'
group by 1;

select min(date(created_at)) as start_week,
count(distinct website_session_id) as sessions,
count(distinct case when n_pageviews='1' then website_session_id else null end) as bounces,
count(distinct case when n_pageviews='1' then website_session_id else null end)/count(distinct website_session_id) as b_perc,
count(distinct case when pageview_url='/home' then website_session_id else null end) as home,
count(distinct case when pageview_url='/lander-1' then website_session_id else null end) as lander
from t1
group by week(created_at);

