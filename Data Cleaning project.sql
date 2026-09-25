-- Data Cleaning
-- 1) Remove Duplocate
-- 2) Standardize the data
-- 3) Null and blank values
-- 4) Remove any columns
USE world_layoff;
create Table layoff_stagging
like layoffs;

select * from layoff_stagging;

insert into layoff_stagging
select * from layoffs;
-- --------------------------------------------------------------------------------------------------------------------------

-- step 1) Removing Duplicates

with duplicate_cte as(
select *,
row_number() over (partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_stagging)
-- select * from duplicate_cte
-- where row_num>1;
delete 
from duplicate_cte
where row_num>1;



CREATE TABLE `layoff_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoff_stagging2;

INSERT INTO layoff_stagging2
select *,
row_number() over (partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_stagging;


delete
from layoff_stagging2
where row_num > 1;

select * from layoff_stagging2;
-- ----------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------ Step 1 Ended(Removing Duplicates ------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------

-- Standarddizing data


select company, trim(company) from layoff_stagging2;

update layoff_stagging2
set company =trim(company);

SELECT DISTINCT
    industry
FROM
    layoff_stagging2
ORDER BY 1;

SELECT DISTINCT
    *
FROM
    layoff_stagging2
where industry like 'Crypto%';

update layoff_stagging2
set industry = 'Crypto' 
where industry like 'crypto%';


select distinct location from layoff_stagging2
order by 1;

select date from layoff_stagging2;


select distinct country, trim(trailing '.' from country) from layoff_stagging2 order by 1;

update layoff_stagging2
set country = trim(trailing '.' from country)
where country like 'united state%';

-- changing date format
select `date`,
str_to_date(`date`, '%m/%d/%Y') as `date`
from layoff_stagging2;

update layoff_stagging2
set date = str_to_date(`date`, '%m/%d/%Y');

select `date` from layoff_stagging2;

-- converting date datatype to int
alter table layoff_stagging2
modify column `date` date;
-- ------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------ Step 2 Ended(Standardize the data) ------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------

-- Step 3) Null and Empty
 
select * from layoff_stagging2
where total_laid_off is null
and percentage_laid_off is null;

select * from layoff_stagging2
where industry is null
or industry = '';

select * from layoff_stagging2
where company = "Bally's Interactive";

select * from layoff_stagging2 t1
join layoff_stagging2 t2
on t1.company = t2.company and
t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- setting empty values to null
update layoff_stagging2
set industry = null
where industry = '';

select * from layoff_stagging2
where industry is null
or industry = '';

update layoff_stagging2 t1
join layoff_stagging2 t2 
on t1.company = t2.company and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;


select * from layoff_stagging2
where total_laid_off is null and
percentage_laid_off is null;
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------- Step 3 Ended(null and empty) -----------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------

-- Remove Column

delete from layoff_stagging2
where total_laid_off is null and
percentage_laid_off is null;

-- Droping Column
alter table layoff_stagging2
drop column row_num;

select * from layoff_stagging2;




















