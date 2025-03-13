/*
===============================================================================
DDL Script: Create Staging Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'staging' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'staging' Tables
===============================================================================
*/

DROP TABLE IF EXISTS staging.film;

CREATE TABLE IF NOT EXISTS staging.film (
	film_id int NOT NULL,
	title varchar(255) NOT NULL,
	description text NULL,
	release_year int2 NULL,
	language_id int2 NOT NULL,
	rental_duration int2 NOT NULL,
	rental_rate numeric(4, 2) NOT NULL,
	length int2 NULL,
	replacement_cost numeric(5, 2) NOT NULL,
	rating varchar(10) NULL,
	last_update timestamp NOT NULL,
	special_features _text NULL,
	fulltext tsvector NOT NULL
);


DROP TABLE IF EXISTS staging.inventory;

CREATE TABLE IF NOT EXISTS staging.inventory (
	inventory_id int NOT NULL,
	film_id int2 NOT NULL,
	store_id int2 NOT NULL,
	last_update timestamp NOT NULL
);


DROP TABLE IF EXISTS staging.rental;

CREATE TABLE IF NOT EXISTS staging.rental (
	rental_id int NOT NULL,
	rental_date timestamp NOT NULL,
	inventory_id int4 NOT NULL,
	customer_id int2 NOT NULL,
	return_date timestamp NULL,
	staff_id int2 NOT NULL,
	last_update timestamp NOT NULL
);


DROP TABLE IF EXISTS staging.payment;

CREATE TABLE IF NOT EXISTS staging.payment (
	payment_id int NOT NULL,
	customer_id int2 NOT NULL,
	staff_id int2 NOT NULL,
	rental_id int4 NOT NULL,
	amount numeric(5, 2) NOT NULL,
	payment_date timestamp NOT NULL
);


DROP TABLE IF EXISTS staging.staff;
CREATE TABLE IF NOT EXISTS staging.staff (
	staff_id int NOT NULL,
	first_name varchar(45) NOT NULL,
	last_name varchar(45) NOT NULL,
	store_id int2 NOT NULL
);


DROP TABLE IF EXISTS staging.address;
CREATE TABLE IF NOT EXISTS staging.address (
	address_id int NOT NULL,
	address varchar(50) NOT NULL,
	district varchar(20) NOT NULL,
	city_id int2 NOT NULL	
);


DROP TABLE IF EXISTS staging.city;
CREATE TABLE IF NOT EXISTS staging.city (
	city_id int NOT NULL,
	city varchar(50) NOT NULL
);

DROP TABLE IF EXISTS staging.store;
CREATE TABLE IF NOT EXISTS staging.store (
	store_id int4 NOT NULL,
	address_id int2  NOT NULL
);