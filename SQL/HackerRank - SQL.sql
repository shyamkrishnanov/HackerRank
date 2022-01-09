/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/

-- select submission_date,hacker_id,max(submissions)
-- from (
select submission_date,hacker_id, count(*) as submissions
from submissions
group by submission_date,hacker_id
having count(*)>1
order by submission_date,submissions,hacker_id
;
-- )
-- group by  submission_date,hacker_id


----
-----TOP EARNERS
--------------


select e.total,count(*)
from (
select *, months*salary as 'total'
from employee ) as e
group by e.total
having e.total = (select max(months*salary) from employee)
--order by e.total desc


-------Pivot
----------OCCupations
set @r1 =0, @r2 =0, @r3 = 0, @r4 = 0;
select min(Doctors),min(Professors),min(Singers),min(Actors)
from (
select 
case when occupation = 'Doctor' then (@r1:=@r1+1)
    when occupation = 'Professor' then (@r2:=@r2+1)
    when occupation = 'Singer' then (@r3:=@r3+1)
    when occupation = 'Actor' then (@r4:=@r4+1)
    end as 'rowNumber',
case when occupation = 'Doctor' then Name end as 'Doctors',
case when occupation = 'Professor' then Name end as 'Professors',
case when occupation = 'Singer' then Name end as 'Singers',
case when occupation = 'Actor' then Name end as 'Actors'
from occupations
order by Name) as e
group by rowNumber

/*
#########
##########FInd Median
*/
select round((
    (select max(e.lat_n)
    from (select top 50 percent lat_n from station order by lat_n)  as e)
    +
    (select max(f.lat_n)
    from (select top 50 percent lat_n from station order by lat_n desc)  as f )
    )/2,4,1) as median
	
	
Select round(S.LAT_N,4) median 
from station S 
where (
    select count(Lat_N) 
    from station 
    where Lat_N < S.LAT_N ) = (
        select count(Lat_N) 
        from station 
        where Lat_N > S.LAT_N
    )
	
select cast(avg(lat_n) as numeric(14,4)) from (
select lat_n,
    row_number() over (order by lat_n asc)  as asc_latn,
    row_number() over (order by lat_n desc) as dsc_latn
from station ) as a 
where asc_latn in (dsc_latn,dsc_latn-1,dsc_latn+1)


select country.continent, floor(avg(city.population))
from city 
left join country  on city.countrycode = country.code
group by country.continent


/*
The report
*/
select 
case when g.grade>=8 then s.name
else null
end as Name, grade, marks
from students s left join grades g on s.marks between g.min_mark and g.max_mark
order by g.grade desc,s.name asc


/*
Top Competitiors*/
select hackers.hacker_id, hackers.name, count(distinct submissions.challenge_id)
from hackers left join challenges on hackers.hacker_id = challenges.hacker_id
left join difficulty on difficulty.difficulty_level = challenges.difficulty_level
left join submissions on hackers.hacker_id = submissions.hacker_id
where difficulty.score = submissions.score
group by hackers.hacker_id, hackers.name
having count(distinct submission_id) > 1
order by count(distinct submission_id) desc, hackers.hacker_id asc


/*
Ollivander's Inventory
*/
select w.id, wp.age, w.coins_needed, w.power
from wands w left join wands_property wp on w.code = wp.code
where wp.is_evil = 0
and w.coins_needed = (
    select min(w1.coins_needed) 
    from wands w1 left join wands_property wp1 on w1.code = wp1.code
    where wp1.is_evil = 0 and w1.code = w.code and wp1.age = wp.age and w1.power = w.power
    group by w1.code,wp1.age,w1.power)
order by w.power desc, wp.age desc