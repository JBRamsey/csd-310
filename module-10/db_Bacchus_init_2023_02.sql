/*
    Title: db_Bacchus_init_2023.sql
    Author: Joshua Ramsey, Karissa Flora
    Date: 1 December 2023
    Description: Bacchus Case Study database initialization script.
*/

-- Create the Bacchus database
CREATE DATABASE IF NOT EXISTS bacchus;

-- Use the Bacchus database for subsequent operations
USE bacchus;

-- drop database user if exists 
DROP USER IF EXISTS 'bacchus_user'@'localhost';


-- create bacchus_user and grant them all privileges to the database 
CREATE USER 'bacchus_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'finewine';

-- grant all privileges to the database to user bacchus_user on localhost 
GRANT ALL PRIVILEGES ON bacchus.* TO 'bacchus_user'@'localhost';


-- drop tables if they are present

DROP TABLE IF EXISTS order_details_t;
DROP TABLE IF EXISTS order_t;
DROP TABLE IF EXISTS timeclock_quarterly_t;
DROP TABLE IF EXISTS supply_inventory_t;
DROP TABLE IF EXISTS company_t;
DROP TABLE IF EXISTS employees_t;
DROP TABLE IF EXISTS product_t;
DROP TABLE IF EXISTS supplier_t;
DROP TABLE IF EXISTS product_cat_t;







-- Create Product Category Table

CREATE TABLE product_cat_t (
    product_cat_id    INT    NOT NULL    AUTO_INCREMENT,
    product_category    VARCHAR(100)    NOT NULL,

    PRIMARY KEY(product_cat_id)
);

-- Create Supplier Table

CREATE TABLE supplier_t (
    supplier_id    INT    NOT NULL    AUTO_INCREMENT,
    supplier_name    VARCHAR(100)    NOT NULL,
    supplier_street  VARCHAR(100)    NOT NULL,
    supplier_city    VARCHAR(50)    NOT NULL,
    supplier_state   CHAR(2)     NOT NULL,
    supplier_zip     VARCHAR(15)     NOT NULL,
    supplier_phone   VARCHAR(15)     NOT NULL,

    PRIMARY KEY(supplier_id)
);

-- Create Product Table

CREATE TABLE product_t (
    product_id     INT    NOT NULL     AUTO_INCREMENT,
    product_name    VARCHAR(100)    NOT NULL,
    unit_price    DECIMAL(5,2)    NOT NULL,
    product_cat_id     INT    NOT NULL,

    PRIMARY KEY(product_id),

    CONSTRAINT product_cat_id_fk
    FOREIGN KEY (product_cat_id)
        REFERENCES product_cat_t(product_cat_id)
);

-- Create the Company Table 

CREATE TABLE company_t (
    company_id     INT             NOT NULL        AUTO_INCREMENT,
    company_name   VARCHAR(100)     NOT NULL,
    company_street  VARCHAR(100)    NOT NULL,
    company_city    VARCHAR(50)    NOT NULL,
    company_state   CHAR(2)     NOT NULL,
    company_zip     VARCHAR(15)     NOT NULL,
    company_phone   VARCHAR(15)     NOT NULL,
     
    PRIMARY KEY(company_id)
); 

-- CREATE EMPLOYEE TABLE

CREATE TABLE employees_t (
    employee_id   INT    NOT NULL    AUTO_INCREMENT,
    employee_name    VARCHAR(100)    NOT NULL,
    employee_position_name    VARCHAR(50)    NOT NULL,
    employee_phone    VARCHAR(15)    NOT NULL,
    employee_email    VARCHAR(50)    NOT NULL,

    PRIMARY KEY(employee_id)
);


-- Create Timeclock Table

CREATE TABLE timeclock_quarterly_t (
    employee_id   INT    NOT NULL,
    timeclock_year    VARCHAR(5)     NOT NULL,
    quarter_1_hours     DECIMAL(5,2)     NOT NULL,
    quarter_2_hours     DECIMAL(5,2)     NOT NULL,
    quarter_3_hours    DECIMAL(5,2)     NOT NULL,
    quarter_4_hours    DECIMAL(5,2)     NOT NULL,

    PRIMARY KEY(employee_id),

    CONSTRAINT timeclock_fk
    FOREIGN KEY (employee_id)
        REFERENCES employees_t(employee_id)
);


-- Create the Supply Inventory Table

CREATE TABLE supply_inventory_t (
    supply_id     INT     NOT NULL     AUTO_INCREMENT,
    supply_name    VARCHAR(50)    NOT NULL,
    supply_inventory_current     INT     NOT NULL,
    supply_inventory_monthly_requirement     INT    NOT NULL,
    supplier_id    INT    NOT NULL,

    PRIMARY KEY(supply_id),

    CONSTRAINT inventory_fk
    FOREIGN KEY (supplier_id)
        REFERENCES supplier_t(supplier_id)
);

-- Create the Orders Table

CREATE TABLE order_t (
    order_id     INT    NOT NULL    AUTO_INCREMENT,
    order_date   DATE    NOT NULL,
    order_shipdate    DATE    NOT NULL,
    company_id    INT    NOT NULL,

    PRIMARY KEY(order_id),

    CONSTRAINT company_fk
    FOREIGN KEY(company_id)
        REFERENCES company_t(company_id)
);

-- Create Order Details Table

CREATE TABLE order_details_t (
    order_id     INT    NOT NULL,
    product_id    INT    NOT NULL,
    quantity    DECIMAL(5,2)    NOT NULL,

    PRIMARY KEY(order_id, product_id),

    CONSTRAINT order_fk
    FOREIGN KEY(order_id)
        REFERENCES order_t(order_id),

    CONSTRAINT product_fk
    FOREIGN KEY (product_id)
        REFERENCES product_t(product_id)
);


-- insert product categories

INSERT INTO product_cat_t(product_category)
    VALUES('Merlot');

INSERT INTO product_cat_t(product_category)
    VALUES('Cabernet');

INSERT INTO product_cat_t(product_category)
    VALUES('Chablis');

INSERT INTO product_cat_t(product_category)
    VALUES('Chardonnay');

-- insert supplier records

INSERT INTO supplier_t(supplier_name, supplier_street, supplier_city, supplier_state, supplier_zip, supplier_phone)
    VALUES('Hermes Bottling Co.', '600 S. East St.', 'New York', 'NY', '012345', '555-1241');

INSERT INTO supplier_t(supplier_name, supplier_street, supplier_city, supplier_state, supplier_zip, supplier_phone)
    VALUES('Thoth Labels', '1st 2nd St.', 'San Francisco', 'CA', '012346', '555-1242');

INSERT INTO supplier_t(supplier_name, supplier_street, supplier_city, supplier_state, supplier_zip, supplier_phone)
    VALUES('Sobek Barrels Inc.', '4550 New Last Rd.', 'Austin', 'TX', '012347', '555-1243');

-- insert product records

INSERT INTO product_t(product_name, unit_price, product_cat_id)
    VALUES('Odin Merlot', 89.99, 1);

INSERT INTO product_t(product_name, unit_price, product_cat_id)
    VALUES('Skadi Merlot', 74.99, 1);

INSERT INTO product_t(product_name, unit_price, product_cat_id)
    VALUES('Sekhmet Cabernet', 129.99, 2);

INSERT INTO product_t(product_name, unit_price, product_cat_id)
    VALUES('Hathor Cabernet', 69.99, 2);

INSERT INTO product_t(product_name, unit_price, product_cat_id)
    VALUES('Chernobog Chablis', 139.99, 3);

INSERT INTO product_t(product_name, unit_price, product_cat_id)
    VALUES('Amaterasu Chardonay', 99.99, 4);

-- insert distributor records

INSERT INTO company_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Ra Fine Dining', '123 Mystic Maple Dr.', 'Austin', 'TX', '78701', '555-1244');

INSERT INTO company_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('The Anubis Club', '456 Lapis Horizon Ln.', 'Austin', 'TX', '78701', '555-1245');

INSERT INTO company_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Horus Wines', '789 Crimson Clover Ct.', 'Seattle', 'WA', '98101', '555-1246');

INSERT INTO company_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Zues Diner', '1011 Whispering Willow Wy.', 'Seattle', 'WA', '98101', '555-1247');

INSERT INTO company_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Ares Nightclub', '1213 Emerald Echo Blvd.', 'Miami', 'FL', '33101', '555-1248');

INSERT INTO company_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Hera-Mart', '1415 Twilight Tango Ter.', 'Miami', 'FL', '33101', '555-1249');

-- insert employee records

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Stan Bacchus', 'Owner', '555-1234', 'sbacchus@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Davis Bacchus', 'Owner', '555-1235', 'dbacchus@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Janet Collins', 'Finance/Payroll', '555-1236', 'jcollins@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Roz Murphy', 'Marketing', '555-1237', 'rmurphy@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Bob Ulrich', 'Assistant', '555-1238', 'bulrich@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Henry Doyle', 'Production Line Manager', '555-1239', 'hdoyle@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Maria Costanza', 'Distribution', '555-1240', 'mcostanza@email.com'); 

-- insert employee timeclock data

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(1, '2022', 520, 580, 600, 500);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(2, '2022', 520, 560, 600, 520);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(3, '2022', 500, 520, 515, 525);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(4, '2022', 520, 520, 520, 520);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(5, '2022', 490, 420, 390, 500);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(6, '2022', 600, 590, 610, 590);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(7, '2022', 500, 490, 510, 480);

-- insert inventory records

INSERT INTO supply_inventory_t(supply_name, supply_inventory_current, supply_inventory_monthly_requirement, supplier_id)
    VALUES('Bottles', 1000, 1500, 1);

INSERT INTO supply_inventory_t(supply_name, supply_inventory_current, supply_inventory_monthly_requirement, supplier_id)
    VALUES('Corks', 1000, 1500, 1);

INSERT INTO supply_inventory_t(supply_name, supply_inventory_current, supply_inventory_monthly_requirement, supplier_id)
    VALUES('Boxes', 100, 150, 2);

INSERT INTO supply_inventory_t(supply_name, supply_inventory_current, supply_inventory_monthly_requirement, supplier_id)
    VALUES('Labels', 100, 150, 2);

INSERT INTO supply_inventory_t(supply_name, supply_inventory_current, supply_inventory_monthly_requirement, supplier_id)
    VALUES('Vats', 5, 6, 3);

INSERT INTO supply_inventory_t(supply_name, supply_inventory_current, supply_inventory_monthly_requirement, supplier_id)
    VALUES('Tubing', 80, 85, 3);


-- insert order records

INSERT INTO order_t(order_date, order_shipdate, company_id)
    VALUES('2023-12-27', '2023-12-29', 1);

INSERT INTO order_t(order_date, order_shipdate, company_id)
    VALUES('2023-12-28', '2023-12-29', 2);

INSERT INTO order_t(order_date, order_shipdate, company_id)
    VALUES('2023-12-28', '2023-12-29', 3);

INSERT INTO order_t(order_date, order_shipdate, company_id)
    VALUES('2023-12-29', '2023-12-29', 4);

INSERT INTO order_t(order_date, order_shipdate, company_id)
    VALUES('2023-12-23', '2023-12-29', 5);

INSERT INTO order_t(order_date, order_shipdate, company_id)
    VALUES('2023-12-12', '2023-12-29', 6);

-- insert order details

INSERT INTO order_details_t (order_id, product_id, quantity)
    VALUES(2, 2, 300);

INSERT INTO order_details_t (order_id, product_id, quantity)
    VALUES(1, 3, 400);

INSERT INTO order_details_t (order_id, product_id, quantity)
    VALUES(3, 2, 200);

INSERT INTO order_details_t (order_id, product_id, quantity)
    VALUES(6, 1, 100);

INSERT INTO order_details_t (order_id, product_id, quantity)
    VALUES(4, 4, 300);

INSERT INTO order_details_t (order_id, product_id, quantity)
    VALUES(5, 1, 200);