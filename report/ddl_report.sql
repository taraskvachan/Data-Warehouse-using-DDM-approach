/*
===============================================================================
DDL Script: Create Report Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'report' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'report' Tables
===============================================================================
*/


DROP TABLE IF EXISTS report.sales_by_dates;
CREATE TABLE report.sales_by_dates (
	date_title varchar(20) not null,
	amount numeric(7,2) not null,
	date_Sort int not null
);

DROP TABLE IF EXISTS report.sales_film;
CREATE TABLE report.sales_film (
	film_title varchar(255) not null,
	amount numeric(7,2) not null 
);

