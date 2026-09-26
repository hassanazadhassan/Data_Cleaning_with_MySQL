select max(total_laid_off) from layoff_stagging2
where percentage_laid_off = 1;

select * from layoff_stagging2
where total_laid_off = 12000;


select max(total_laid_off), max(percentage_laid_off) from layoff_stagging2;

select * from layoff_stagging2
where percentage_laid_off=1
order by funds_raised_millions desc;

#Company
select company, sum(total_laid_off) from layoff_stagging2
group by company
order by 2 desc;

select min(`date`), max(`date`) from layoff_stagging2;
#Industry
select industry, sum(total_laid_off) from layoff_stagging2
group by industry
order by 2 desc;

##Country
select country, sum(total_laid_off) from layoff_stagging2
group by country
order by 2 desc;

#Roling over by month
with rolling_over as (
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as laid_off_by_month from layoff_stagging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc)

select `Month`, laid_off_by_month, sum(laid_off_by_month) over(order by `Month`) as rolling_total from rolling_over;

select company, year(`Date`),sum(total_laid_off) as laid_off from layoff_stagging2
group by company, year(`Date`)
;

with company_laid_off (company, years, laid_off) as (
select company, year(`Date`) ,sum(total_laid_off) from layoff_stagging2
group by company, year(`Date`)
), company_year_rank as
(
select *, 
dense_rank() over(partition by years order by laid_off desc) as ranking
from company_laid_off
where years is not null
)

select * from company_year_rank
where ranking <=5;
