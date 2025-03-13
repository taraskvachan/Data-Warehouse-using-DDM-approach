/*
===============================================================================
DDL Script: Create Core Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'core' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'core' Tables
===============================================================================
*/

DROP TABLE IF EXISTS core.dim_inventory CASCADE;
create table core.dim_inventory (
	inventory_pk serial primary key,
	inventory_id int not null,
	film_id int not null,
	title varchar(255) not null,
	rental_duration int2 not null,
	rental_rate numeric(4, 2) not null,
	length int2,
	rating varchar(10)
);

DROP TABLE IF EXISTS core.dim_staff CASCADE;
create table core.dim_staff (
	staff_pk serial  primary key,
	staff_id int not null,
	first_name varchar(45) not null,
	last_name varchar(45) not null,
	address varchar(50) not null,
	district varchar(20) not null,
	city varchar(50) not null	
);

DROP TABLE IF EXISTS core.fact_payment;
create table core.fact_payment (
	payment_pk serial  primary key,
	payment_id int not null,
	amount numeric(7, 2) not null,
	payment_date date not null,
	inventory_fk int not null references core.dim_inventory(inventory_pk),
	staff_fk int not null references core.dim_staff(staff_pk)
);

DROP TABLE IF EXISTS core.fact_rental;
create table core.fact_rental (
	rental_pk serial primary key,
	rental_id int not null,
	inventory_fk int not null references core.dim_inventory(inventory_pk),
	staff_fk int not null references core.dim_staff(staff_pk),
	rental_date date not null,
	return_date date,
	cnt int2 not null,
	amount numeric(7, 2)
);

DROP TABLE if exists core.dim_date;
CREATE TABLE core.dim_date
(
  date_dim_pk              INT PRIMARY KEY,
  date_actual              DATE NOT NULL,
  epoch                    BIGINT NOT NULL,
  day_suffix               VARCHAR(4) NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  week_of_year_iso         CHAR(10) NOT NULL,
  month_actual             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_actual           INT NOT NULL,
  quarter_name             VARCHAR(9) NOT NULL,
  year_actual              INT NOT NULL,
  first_day_of_week        DATE NOT NULL,
  last_day_of_week         DATE NOT NULL,
  first_day_of_month       DATE NOT NULL,
  last_day_of_month        DATE NOT NULL,
  first_day_of_quarter     DATE NOT NULL,
  last_day_of_quarter      DATE NOT NULL,
  first_day_of_year        DATE NOT NULL,
  last_day_of_year         DATE NOT NULL,
  mmyyyy                   CHAR(6) NOT NULL,
  mmddyyyy                 CHAR(10) NOT NULL,
  weekend_indr             BOOLEAN NOT NULL
);

CREATE INDEX dim_date_date_actual_idx
  ON core.dim_date(date_actual);

