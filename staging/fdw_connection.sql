/*
===============================================================================
SQL script: FDW connection
===============================================================================
This SQL script sets up a foreign data wrapper (FDW) connection in PostgreSQL to access a remote database. 
===============================================================================
*/

-- Enable Foreign Data Wrapper Extension
CREATE EXTENSION postgres_fdw;

-- Create a Foreign Server
CREATE SERVER film_pg FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
	host 'localhost',
	dbname 'postgres',
	port '5433'
);

-- Create a User Mapping
CREATE USER MAPPING FOR postgres SERVER film_pg OPTIONS (
	user 'postgres',
	password 'postgres'
);

-- Create a Local Schema
DROP SCHEMA IF EXISTS film_src;
CREATE SCHEMA film_src AUTHORIZATION postgres;

-- Define Custom Data Types
DROP TYPE IF EXISTS mpaa_rating;
CREATE TYPE public.mpaa_rating AS ENUM (
	'G',
	'PG',
	'PG-13',
	'R',
	'NC-17');

CREATE DOMAIN public.year AS integer
	CHECK (VALUE >= 1901 AND VALUE <= 2155);

-- Import Tables from the Remote Server
IMPORT FOREIGN SCHEMA publicFROM SERVER film_pg INTO film_src;



