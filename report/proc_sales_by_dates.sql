/*
===============================================================================
Stored Procedure: Sales by date
===============================================================================
Script Purpose:
    This function creates a report that shows the sales amount by movie. The function that returns the data for visualization returns the fields:
	1. film_title - the name of the movie
	2. amount - the sales amount by movie
===============================================================================
*/

CREATE OR REPLACE PROCEDURE report.sales_by_dates_calc()
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE '>> Truncating Table: report.sales_by_dates';
	TRUNCATE TABLE report.sales_by_dates;

	RAISE NOTICE '>> Inserting Data Into: report.sales_by_dates';	
	INSERT INTO report.sales_by_dates (
		date_title,
		amount,
		date_sort
	)
	SELECT 
		dd.day_of_month || ' ' || dd.month_name || ' ' || dd.year_actual AS date_title,
		sum(fp.amount) as amount,
		dd.date_dim_pk as date_sort
	FROM 
		core.fact_payment fp
	JOIN core.dim_date dd
		ON fp.payment_date_fk = dd.date_dim_pk
	GROUP BY
		dd.day_of_month || ' ' || dd.month_name || ' ' || dd.year_actual,
		dd.date_dim_pk; 
END;
$$;

CALL report.sales_by_dates_calc()


	
