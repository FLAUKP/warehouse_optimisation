-- Optimized Results prelim --
create view opt_result1 as
select team_size, cast(assign_timestamp_start as Date) date, w.worker_id, w.name,
	sum(r.assign_time) as total_assign_time, max(w.salaryperhr) as salary_per_hr
from job_assignment_result as r
left join dropzone_workers_all as w
on w.worker_id = r.assign_worker
group by team_size, date, w.worker_id, w.name
order by team_size DESC, date;

-- Optimized Results final --
create view opt_result2 as
select *, (total_assign_time * salary_per_hr / 60.0) as worker_earn, 
	(case 
	 when EXTRACT(DOW FROM date) = 6 then (total_assign_time / 60 * salary_per_hr * 1.5)
	 when total_assign_time < 480 then (salary_per_hr * 8 ) 
	 else (salary_per_hr * 8 ) + (total_assign_time - 480) * (salary_per_hr * 1.5 / 60.0) end) as worker_paid
from opt_result1;

-- UN-Optimized Results final --
create view un_opt_result1 as
select team_size, cast(assign_timestamp_start as Date) date, v.worker_id, v.name,
	sum(q.assign_time) as total_assign_time, max(v.salaryperhr) as salary_per_hr
from job_assignment_result_noopt as q
left join dropzone_workers_all as v
on v.worker_id = q.assign_worker
group by team_size, date, v.worker_id, v.name
order by team_size DESC, date;

-- UN-Optimized Results final --
create view un_opt_result2 as
select *, (total_assign_time * salary_per_hr / 60.0) as worker_earn, 
	(case
	 when EXTRACT(DOW FROM date) = 6 then (total_assign_time / 60 * salary_per_hr * 1.5)
	 when total_assign_time < 480 then (salary_per_hr * 8 ) 
	 else (salary_per_hr * 8 ) + (total_assign_time - 480) * (salary_per_hr * 1.5 / 60.0) end) as worker_paid
from un_opt_result1


