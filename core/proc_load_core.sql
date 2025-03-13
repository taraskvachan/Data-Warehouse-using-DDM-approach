/*
===============================================================================
Stored Procedure: Load Core Layer (staging -> core)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'core' schema from 'staging' schema. 
    It performs the following actions:
    - Truncates the staging tables before loading data.
    - Load data from foreign tables to staging tables.
===============================================================================
*/

CREATE OR REPLACE PROCEDURE core.load_core()
LANGUAGE plpgsql
AS $$
BEGIN
    
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Core Layer';
    RAISE NOTICE '================================================';
    
    -- Load core.dim_inventory
    
    RAISE NOTICE '>> Truncating Table: core.dim_inventory';
    DELETE FROM  core.dim_inventory;
    
    RAISE NOTICE '>> Inserting Data Into: core.dim_inventory';
    INSERT INTO core.dim_inventory (
	inventory_id, 
	film_id, 
	title, 
	rental_duration, 
	rental_rate, 
	length, 
	rating
    )
    SELECT
    	i.inventory_id,
    	f.film_id, 
	f.title, 
	f.rental_duration,
	f.rental_rate, 
	f.length, 
	f.rating
    FROM
 	staging.inventory i
    JOIN
    	staging.film f
    USING(film_id);
    
    -- Load core.dim_staff

    RAISE NOTICE '>> Truncating Table: core.dim_staff';
    DELETE FROM  core.dim_staff;
    
    RAISE NOTICE '>> Inserting Data Into: core.dim_staff';
    INSERT INTO core.dim_staff (
	staff_id, 
	first_name, 
	last_name, 
	address, 
	district, 
	city
    )
    SELECT
	s.staff_id,
	s.first_name, 
	s.last_name, 
	a.address, 
	a.district,
	c.city
    FROM
 	staging.staff s
    JOIN
    	staging.store st USING(store_id)
    JOIN
    	staging.address a USING(address_id)
    JOIN
    	staging.city c USING(city_id);	

    -- Load core.fact_payment

    RAISE NOTICE '>> Truncating Table: core.fact_payment';
    TRUNCATE TABLE core.fact_payment;
    
    RAISE NOTICE '>> Inserting Data Into: core.fact_payment';
    INSERT INTO core.fact_payment (
	payment_id,
	amount, 
        payment_date, 
	inventory_fk, 
	staff_fk
    )
    SELECT
	p.payment_id,
	p.amount,
	p.payment_date::DATE AS payment_date,
	di.inventory_pk AS inventory_fk,
	ds.staff_pk AS staff_fk
    FROM
 	staging.payment p
    JOIN
    	staging.rental r USING(rental_id)
    JOIN
    	core.dim_inventory di USING(inventory_id)
    JOIN
    	core.dim_staff ds ON p.staff_id = ds.staff_id;

    -- Load core.fact_rental

    RAISE NOTICE '>> Truncating Table: core.fact_rental';
    TRUNCATE TABLE core.fact_rental;
    
    RAISE NOTICE '>> Inserting Data Into: core.fact_rental';
    INSERT INTO core.fact_rental (
	rental_id,
	inventory_fk,
	staff_fk,
	rental_date,
        return_date,
	amount,
	cnt
    )
    SELECT
	r.rental_id,
	i.inventory_pk AS inventory_fk,
	s.staff_pk AS staff_fk,
	r.rental_date::DATE AS rental_date,
	r.return_date::DATE AS return_date,
	SUM(p.amount) AS amount,
	COUNT(*) AS cnt
    FROM
	staging.rental r
    JOIN 
	core.dim_inventory i USING(inventory_id)
    JOIN 
	core.dim_staff s ON s.staff_id = r.staff_id
    LEFT JOIN
	staging.payment p USING(rental_id)
    GROUP BY
	r.rental_id,
	i.inventory_pk,
	s.staff_pk,
	r.rental_date::DATE,
	r.return_date::DATE;

    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Core Layer is Completed';
    RAISE NOTICE '==========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING CORE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE '==========================================';
END;
$$;


/*
===============================================================================
Stored Procedure: Truncate Fact Tables 
===============================================================================
Script Purpose:
    This stored procedure truncate fact Tables 
===============================================================================
*/

CREATE OR REPLACE PROCEDURE core.truncate_fact_tables()
LANGUAGE plpgsql
AS $$
begin
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Truncating Fact Tables';
    RAISE NOTICE '================================================';
	
    TRUNCATE TABLE core.fact_rental;
    TRUNCATE TABLE core.fact_payment;

    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Truncating Fact Tables is Completed';
    RAISE NOTICE '==========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING TRUNCATING FACT TABLES';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE '==========================================';
END;
$$;
	

CREATE OR REPLACE PROCEDURE core.full_load()
LANGUAGE plpgsql
AS $$
begin
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Full Core Layer loading';
    RAISE NOTICE '================================================';
	
    CALL core.truncate_fact_tables();
    CALL core.load_core();

    RAISE NOTICE '==========================================';
    RAISE NOTICE 'FULL CORE LAYER LOADING is Completed';
    RAISE NOTICE '==========================================';

END;
$$;


CALL core.full_load();




