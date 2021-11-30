--Creacio de la taula Employee Offering
DROP TABLE IF EXISTS Employee_Offering CASCADE;  
CREATE TABLE Employee_Offering(   
	id SERIAL,
	email VARCHAR(255),
	job VARCHAR(255),
	full_name VARCHAR(255),   
	department VARCHAR(255),      
	job_offering TEXT,
	jo_status TEXT, 
	jo_date DATE    
); 
COPY Employee_Offering FROM 'C:\Users\Public\Taules_bbdd1\bbdd_s1_employee_offering.csv' DELIMITER ',' QUOTE '"' CSV HEADER;

--En aquesta taula tenim la mateixa informacio que en Employee_Offering, pero guardem en nom i cognom en dos atributs diferents
--com a la resta de taules, first_name i last_name.
DROP TABLE IF EXISTS Employee_Offering_bo CASCADE;  
CREATE TABLE Employee_Offering_bo(
	id SERIAL,
	email VARCHAR(255),
	job VARCHAR(255),
	first_name VARCHAR(255),
	last_name VARCHAR(255),   
	department VARCHAR(255),    
	job_offering TEXT,
	jo_status TEXT,  
	jo_date DATE 
);
INSERT INTO Employee_Offering_bo (email, job, first_name, last_name, department, job_offering, jo_status, jo_date)
SELECT email, job,
	SUBSTRING(full_name, 1, STRPOS(full_name, ' ') - 1),
	SUBSTRING(full_name, STRPOS(full_name, ' ') + 1, LENGTH(full_name)),
	department, job_offering, jo_status, jo_date
FROM Employee_Offering;

--Creacio de la taula Person Review
DROP TABLE IF EXISTS Person_Review CASCADE;
CREATE TABLE Person_Review(
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR (255),
    credit_card VARCHAR(255),
    credit_card_type VARCHAR(255),  
    month INTEGER,
    year INTEGER,
    address TEXT,
    city VARCHAR(255),
    country VARCHAR(255),
    postal_code VARCHAR(255),
    orderItemID INTEGER,
    review TEXT,
    score VARCHAR(255)
);
COPY Person_Review FROM 'C:\Users\Public\Taules_bbdd1\bbdd_s1_person_review.csv' DELIMITER ',' QUOTE '"' CSV HEADER;

--Creacio de la taula Product Category
DROP TABLE IF EXISTS Product_Category CASCADE;
CREATE TABLE Product_Category(
    Category1 VARCHAR(255),
    Category2  VARCHAR(255), 
    Category3 VARCHAR(255)   
);
COPY Product_Category FROM 'C:\Users\Public\Taules_bbdd1\bbdd_s1_product_category.csv' DELIMITER ';' QUOTE '"' CSV HEADER;
 

--Creacio de la taula Product Document
DROP TABLE IF EXISTS Product_Document CASCADE;
CREATE TABLE Product_Document(
    ID INTEGER,
    name VARCHAR(255),
    description TEXT,  
    date DATE, 
    path TEXT,
    pages INTEGER,
    duration INTEGER, 
    resolution VARCHAR(255)
);
COPY Product_Document FROM 'C:\Users\Public\Taules_bbdd1\bbdd_s1_product_document.csv' DELIMITER ',' QUOTE '"' CSV HEADER;

--Creacio de la taula Vehicle Driver
DROP TABLE IF EXISTS Vehicles_Drivers CASCADE;
CREATE TABLE Vehicles_Drivers(
	first_name VARCHAR(255), 
	last_name VARCHAR(255),
	email VARCHAR(255), 
	phone VARCHAR(255),
	address VARCHAR(255),
	city VARCHAR(255),
	country VARCHAR(255),  
	postal_code VARCHAR(255),
	model_status VARCHAR(255),
	status VARCHAR(255), 
	cargo INTEGER,
	driving_hours INTEGER,
	orders INTEGER,
	battery INTEGER,
	license_plate VARCHAR(255),
	engine_power INTEGER 
);
COPY Vehicles_Drivers FROM 'C:\Users\Public\Taules_bbdd1\bbdd_s1_vehicles_drivers.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
