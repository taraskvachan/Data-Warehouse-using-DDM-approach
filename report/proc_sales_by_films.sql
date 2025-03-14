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
	SELECT
		di.title as film_title,
		sum(p.amount) as amout
	FROM
		core.fact_payment p
	JOIN core.dim_inventory di 
		ON p.inventory_fk = di.inventory_pk 
	GROUP BY
		di.title;
END;
$$;

CALL report.sales_film_calc()

	
