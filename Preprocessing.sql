use sql_and_tableau;

-- checking if the enroll date is after the finish date (should be imposible)
select date_enrolled , date_completed
from career_track_student_enrollments
where date_enrolled>date_completed;

-- Final table to export
with firsts_columns as (select row_number() over(order by cs.student_id, ct.track_name) as student_track_id , 
								cs.student_id, 
								ct.track_name,
                                cs.date_enrolled,
								case when cs.date_completed is null then 0 else 1 end as track_completed,
								case when cs.date_completed is null then 'Not completed yet' 
									else DATEDIFF(cs.date_completed, cs.date_enrolled) end as days_for_completion
						from career_track_student_enrollments cs join career_track_info ct 
							on cs.track_id = ct.track_id)
select student_track_id , student_id, track_name, date_enrolled, track_completed, days_for_completion,
		case when days_for_completion = 'Not completed yet' then 'Not completed yet'
			when days_for_completion between 1 and 7 then '1 to 7 days'
            when days_for_completion between 8 and 30 then '8 to 30 days'
            when days_for_completion between 31 and 60 then '31 to 60 days'
            when days_for_completion between 61 and 90 then '61 to 90 days'
            when days_for_completion between 91 and 365 then '91 to 365 days'
            when days_for_completion > 365 then '366+'
			else 'Same day' end as completion_bucket 
from  firsts_columns;


