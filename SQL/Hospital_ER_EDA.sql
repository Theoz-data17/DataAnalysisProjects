
-- Changing date column in admission details to standard sql date

update Hospital_ER.hospital_admission_details 
set date = str_to_date(date, '%d/%m/%Y');


-- what is the average age of all patients admitted at the hospital?

select round(Avg(patient_age)) as Average_Age
from patient_details;

-- What is the average age by gender?


create view Avg_age_by_gender
as
select
	patient_gender,
	avg(patient_age) as average_age
from patient_details 
group by patient_gender;

select * from Avg_age_by_gender;

-- What is the average by department referral?

create view avg_age_dptmnt
as
select
	had.department_referral,
	Avg(pd.patient_age) as average_age
from patient_details pd
join hospital_admission_details had 
	using(patient_id)
group by had.department_referral;

select * from avg_age_dptmnt ;

-- whats the most common race amongst the hospital patients?

create view race_count
as
select 
	patient_race as race,
	count(patient_race) as number_of_patients
from patient_details
group by race
order by number_of_patients desc;

select * from race_count;

-- waiting time
 
-- Avg waiting time of patients(all)

select 
	avg(patient_waittime) as avg_waittime
from patient_details pd
join hospital_admission_details had 
	using(patient_id);

-- Avg waiting time of patients separated by gender
select 
	pd.patient_gender,
	avg(had.patient_waittime) as avg_waittime
from patient_details pd
join hospital_admission_details had 
	using(patient_id)
group by pd.patient_gender
order by avg_waittime;

-- Avg waiting time of patients separated by departmental_referral
create view department_avg_waittime
as
select 
	had.department_referral,
	avg(had.patient_waittime)  as avg_waittime
from patient_details pd
join hospital_admission_details had 
	using(patient_id)
group by had.department_referral 
order by avg_waittime;

select * from department_avg_waittime;


-- Avg waiting time of patients separated by race
create view racial_avg_waittime
as
select 
	pd.patient_race ,
	pd.patient_gender,
	avg(had.patient_waittime)  as avg_waittime
from patient_details pd
join hospital_admission_details had 
	using(patient_id)
group by pd.patient_race , pd.patient_gender
order by pd.patient_race;

select * from racial_avg_waittime;

-- adding total_avg to racial average waiting time
select 
	patient_race,
	patient_gender,
	avg_waittime,
	avg(avg_waittime) over (partition by patient_race) as total_average
from racial_avg_waittime;

		
-- Which department had the highest average patient satisfaction score

create view department_total_patient_sat_score
as
select
	had.department_referral,
	sum(had.patient_sat_score) as total_patient_sat_score
from patient_details pd
join hospital_admission_details had 
	using(patient_id)
group by had.department_referral
order by total_patient_sat_score DESC;

select * from department_total_patient_sat_score;




