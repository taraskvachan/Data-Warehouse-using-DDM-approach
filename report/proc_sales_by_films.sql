/*
===============================================================================
Stored Procedure: Sales by films
===============================================================================
Script Purpose:
    A procedure that creates a report that shows the sales amount by movie. The function that returns the data for visualization should return the fields:
	1. film_title - the name of the movie
	2. amount - the sales amount by movie
===============================================================================
*/;


CREATE OR REPLACE PROCEDURE report.sales_film_calc()
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE '>> Truncating Table: report.sales_film';
	TRUNCATE TABLE report.sales_film;

	RAISE NOTICE '>> Inserting Data Into: report.sales_film';
		INSERT INTO report.sales_film
		(
			film_title, 
			amount
		)
		select
			di.title as film_title,
			sum(p.amount) as amout
		from
			core.fact_payment p
			join core.dim_inventory di 
				on p.inventory_fk = di.inventory_pk 
		group by
			di.title;
END;
$$;

call report.sales_film_calc()

	