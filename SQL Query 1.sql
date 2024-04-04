create view batsmen_season2 as
 select balls,runs,out_notout,batsmanName,substring_index(matchDate,',',-1) as season
 from dim_match_summary
 join fact_bating_summary on 
fact_bating_summary.match_id = dim_match_summary.match_id;

with cte1 as(
select batsmanName,
 sum(case when season=2021 then runs else 0 end) as Runs_2021,
 sum(case when season=2022 then runs else 0 end) as Runs_2022,
 sum(case when season=2023 then runs else 0 end) as Runs_2023,
 sum(case when season=2021 then balls else 0 end) as balls_2021,
 sum(case when season=2022 then balls else 0 end) as balls_2022,
 sum(case when season=2023 then balls else 0 end) as balls_2023,
 count(case when out_notout='out' then 1 else null end) as total_out 
  from batsmen_season2
group by batsmanName),
cte2 as(
select *,(Runs_2021+Runs_2022+Runs_2023) as total_runs
 from cte1 where 
balls_2021>=60 and balls_2022>=60 and balls_2023>=60),
cte3 as(
select * ,round((total_runs/total_out),2) as batting_average from cte2)
select batsmanName , batting_average from cte3 
order by batting_average desc limit 10;