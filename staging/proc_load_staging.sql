/*
===============================================================================
Stored Procedure: Load Staging Layer (source -> staging)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'staging' schema from foreign tables. 
    It performs the following actions:
    - Truncates the staging tables before loading data.
    - Load data from foreign tables to staging tables.
===============================================================================
*/

CREATE OR REPLACE PROCEDURE staging.load_staging()
LANGUAGE plpgsql
AS $$
BEGIN
    
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Staging Layer';
    RAISE NOTICE '================================================';

    -- Load staging.film
    
    RAISE NOTICE '>> Truncating Table: staging.film';
    TRUNCATE TABLE staging.film;
    
    RAISE NOTICE '>> Inserting Data Into: staging.film';
    INSERT INTO staging.film (
    	film_id, 
    	title, 
    	description, 
    	release_year, 
    	language_id, 
    	rental_duration, 
    	rental_rate, 
    	length, 
    	replacement_cost, 
    	rating, 
    	last_update, 
    	special_features, 
    	fulltext
    )
	SELECT 
		film_id, 
		title, 
		description, 
		release_year, 
		language_id, 
		rental_duration, 
		rental_rate, 
		length, 
		replacement_cost, 
		rating, 
		last_update, 
		special_features, 
		fulltext
	FROM 
		film_src.film;

	-- Load staging.inventory
	
	RAISE NOTICE '>> Truncating Table: staging.inventory';
    TRUNCATE TABLE staging.inventory;
    
    RAISE NOTICE '>> Inserting Data Into: staging.inventory';
	INSERT INTO staging.inventory (
		inventory_id,
		film_id,
		store_id,
		last_update 
	)
    SELECT 
		inventory_id,
		film_id,
		store_id,
		last_update 
	FROM 
		film_src.inventory;

	-- Load staging.rental

	RAISE NOTICE '>> Truncating Table: staging.rental';
    TRUNCATE TABLE staging.rental;
    
    RAISE NOTICE '>> Inserting Data Into: staging.rental';
	INSERT INTO staging.rental (
		rental_id,
		rental_date,
		inventory_id,
		customer_id,
		return_date,
		staff_id,
		last_update
	)
    SELECT 
		rental_id,
		rental_date,
		inventory_id,
		customer_id,
		return_date,
		staff_id,
		last_update
	FROM 
		film_src.rental;

	-- Load staging.payment

	RAISE NOTICE '>> Truncating Table: staging.payment';
    TRUNCATE TABLE staging.payment;
    
    RAISE NOTICE '>> Inserting Data Into: staging.payment';
	INSERT INTO staging.payment (	
		payment_id,
		customer_id,
		staff_id,
		rental_id,
		amount,
		payment_date
	)
	SELECT
		payment_id,
		customer_id,
		staff_id,
		rental_id,
		amount,
		payment_date
	FROM
		film_src.payment;
    
    -- Load staging.staff

	RAISE NOTICE '>> Truncating Table: staging.staff';
    TRUNCATE TABLE staging.staff;
    
    RAISE NOTICE '>> Inserting Data Into: staging.staff';
	INSERT INTO staging.staff (
		staff_id,
		first_name,
		last_name,
		store_id
	)
	SELECT
		staff_id,
		first_name,
		last_name,
		store_id
	FROM
		film_src.staff;
    
    -- Load staging.address

	RAISE NOTICE '>> Truncating Table: staging.address';
    TRUNCATE TABLE staging.address;
    
    RAISE NOTICE '>> Inserting Data Into: staging.address';
    INSERT INTO staging.address (
    	address_id,
		address,
		district,
		city_id	
    )
    SELECT
    	address_id,
		address,
		district,
		city_id	
	FROM
		film_src.address;
    
    -- Load staging.city

	RAISE NOTICE '>> Truncating Table: staging.city';
    TRUNCATE TABLE staging.city;
    
    RAISE NOTICE '>> Inserting Data Into: staging.city';
    INSERT INTO staging.city (
    	city_id,
		city
	)
	SELECT
		city_id,
		city
	FROM
		film_src.city;

    -- Load staging.store

    RAISE NOTICE '>> Truncating Table: staging.store';
    TRUNCATE TABLE staging.store;
    
    RAISE NOTICE '>> Inserting Data Into: staging.store';
    INSERT INTO staging.store (
    	store_id,
	address_id 
	)
	SELECT
		store_id,
		address_id 
	FROM
		film_src.store;
		
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Staging Layer is Completed';
    RAISE NOTICE '==========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING STAGING LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE '==========================================';
END;
$$;

CALL staging.load_staging()
