/*
==============================
Create Database And Schemas
==============================
Script Purpose
This script creates a new database named 'ECOMDB' after checking if it already exists
.If the database exists, it is dropped and recreated. Aditionally, the script sets up three
schemas within the database: 'ec_staging','ec_core','ec_datamart'.
Warning
Running this script will drop the entire "ECOMDB" database if it exists.
All data in the database will be permanently deleted.Proceed with caution 
and ensure you have proper backups before running this scripts.
*/
USE master;
GO

--Drop and recreate the 'ECOMDB' database 
IF EXISTS (SELECT 1 FROM sys.databases WHERE name='ECOMDB')
BEGIN
ALTER DATABASE ECOMDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE ECOMDB;
END;
GO
--Create the 'ECOMDB' DATABASE
CREATE DATABASE ECOMDB ;
GO

--CREATE SCHEMAS
USE ECOMDB;
GO

CREATE SCHEMA ec_staging;
GO

CREATE SCHEMA ec_core;
GO

CREATE SCHEMA ec_datamart;
GO
