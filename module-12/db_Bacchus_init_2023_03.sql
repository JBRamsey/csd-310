/*
    Title: db_Bacchus_init_2023_03.sql
    Author: Joshua Ramsey, Karissa Flora
    Date: 9 December 2023
    Description: Bacchus Case Study database initialization script.
*/

-- Are suppliers delivering on time? Is there a large gap between expected delivery and actual delivery?
-- A month by month report should show problem areas. 
-- Are all wines selling as expected. Is one wine not selling? Which distributor carries which wine? **Need way to check wine sales.
-- During the last four quarters, how many hours did each employee work? **This should work. Run all quarters through SUM to find out totals?

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

DROP TABLE IF EXISTS order_distribution_details_t;
DROP TABLE IF EXISTS order_distribution_t;
DROP TABLE IF EXISTS timeclock_quarterly_t;
DROP TABLE IF EXISTS supply_inventory_t;
DROP TABLE IF EXISTS supply_orders_t;
DROP TABLE IF EXISTS distribution_t;
DROP TABLE IF EXISTS company_t;
DROP TABLE IF EXISTS employees_t;
DROP TABLE IF EXISTS product_t;
DROP TABLE IF EXISTS supplier_t;
DROP TABLE IF EXISTS product_cat_t;


-- Create Product Category Table: This table shows what category each of Bacchus' wines is, Merlot, Charbdis, Cabernet, or Chardonnay

CREATE TABLE product_cat_t (
    product_cat_id    INT    NOT NULL    AUTO_INCREMENT,
    product_category    VARCHAR(100)    NOT NULL,

    PRIMARY KEY(product_cat_id)
);

-- Create Supplier Table: This table lists the various suppliers that supply equipment to Bacchus for them to make wine.

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

-- Create Product Table: This table lists the various products that Bacchus sells to its distributors, it's category, price, and name.

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

-- Create the Company Table: This table lists the distributors that Bacchus sells their wine to.

CREATE TABLE distribution_t (
    distribution_id     INT             NOT NULL        AUTO_INCREMENT,
    company_name   VARCHAR(100)     NOT NULL,
    company_street  VARCHAR(100)    NOT NULL,
    company_city    VARCHAR(50)    NOT NULL,
    company_state   CHAR(2)     NOT NULL,
    company_zip     VARCHAR(15)     NOT NULL,
    company_phone   VARCHAR(15)     NOT NULL,
     
    PRIMARY KEY(distribution_id)
); 

-- CREATE EMPLOYEE TABLE: This table lists all of the employees that Bacchus employs. 

CREATE TABLE employees_t (
    employee_id   INT    NOT NULL    AUTO_INCREMENT,
    employee_name    VARCHAR(100)    NOT NULL,
    employee_position_name    VARCHAR(50)    NOT NULL,
    employee_phone    VARCHAR(15)    NOT NULL,
    employee_email    VARCHAR(50)    NOT NULL,

    PRIMARY KEY(employee_id)
);


-- Create Timeclock Table: For each of Bacchus' employees, this table determines the end of year quarterly hours for each employee.

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


-- Create the Supply Inventory Table: This table determines needed supplies, how many are needed each month and how many are currently in stock.

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

-- Supply Orders Inventory Table: This table displays orders from suppliers for supplies to make wine.

CREATE TABLE supply_orders_t (
    supply_order_id   INT    NOT NULL    AUTO_INCREMENT,
    supply_id    INT    NOT NULL,
    quantity   DECIMAL(7,2)   NOT NULL,
    order_date    DATE     NOT NULL,
    order_shipdate    DATE    NOT NULL,
    order_expecteddate    DATE NOT NULL,
    order_arrivaldate    DATE NOT NULL,

    PRIMARY KEY(supply_order_id),

    CONSTRAINT supply_order_fk
    FOREIGN KEY (supply_id)
        REFERENCES supply_inventory_t(supply_id)

);

-- Create the Orders Distribution Table: This Table determines the orders from the distributors to Bacchus.

CREATE TABLE order_distribution_t (
    order_distribution_id     INT    NOT NULL    AUTO_INCREMENT,
    order_date   DATE    NOT NULL,
    order_shipdate    DATE    NOT NULL,
    order_arrivaldate    DATE   NOT NULL,
    distribution_id    INT    NOT NULL,

    PRIMARY KEY(order_distribution_id),

    CONSTRAINT distribution_fk
    FOREIGN KEY(distribution_id)
        REFERENCES distribution_t(distribution_id)
);

-- Create Order Details Table

CREATE TABLE order_distribution_details_t (
    order_distribution_id     INT    NOT NULL,
    product_id    INT    NOT NULL,
    quantity    DECIMAL(5,2)    NOT NULL,
    subtotal_cost    DECIMAL(10,2)    NOT NULL,

    PRIMARY KEY(order_distribution_id, product_id),

    CONSTRAINT order_distribution_fk
    FOREIGN KEY(order_distribution_id)
        REFERENCES order_distribution_t(order_distribution_id),

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

INSERT INTO distribution_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Ra Fine Dining', '123 Mystic Maple Dr.', 'Austin', 'TX', '78701', '555-1244');

INSERT INTO distribution_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('The Anubis Club', '456 Lapis Horizon Ln.', 'Austin', 'TX', '78701', '555-1245');

INSERT INTO distribution_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Horus Wines', '789 Crimson Clover Ct.', 'Seattle', 'WA', '98101', '555-1246');

INSERT INTO distribution_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Zues Diner', '1011 Whispering Willow Wy.', 'Seattle', 'WA', '98101', '555-1247');

INSERT INTO distribution_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
    VALUES('Ares Nightclub', '1213 Emerald Echo Blvd.', 'Miami', 'FL', '33101', '555-1248');

INSERT INTO distribution_t(company_name, company_street, company_city, company_state, company_zip, company_phone)
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

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('John Smith', 'Line Production', '555-1241', 'jsmith@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Emily Johnson', 'Line Production', '555-1242', 'ejohnson@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Michael Davis', 'Line Production', '555-1243', 'mdavis@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Samantha Wilson', 'Line Production', '555-1244', 'swilson@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Ryan Thompson', 'Line Production', '555-1245', 'rthompson@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Amanda Rodriguez', 'Line Production', '555-1246', 'arodriguez@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Daniel Martinez', 'Line Production', '555-1247', 'dmartinez@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Jessica Lee', 'Line Production', '555-1248', 'jlee@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('David Clark', 'Line Production', '555-1249', 'dclark@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Ashley Turner', 'Line Production', '555-1250', 'aturner@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Christopher Brown', 'Line Production', '555-1251', 'cbrown@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Alexandra White', 'Line Production', '555-1252', 'awhite@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Brandon Harris', 'Line Production', '555-1253', 'bharris@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Taylor Nelson', 'Line Production', '555-1254', 'tnelson@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Jordan Miller', 'Line Production', '555-1255', 'jmiller@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Kayla Hall', 'Line Production', '555-1256', 'khall@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Matthew Turner', 'Line Production', '555-1257', 'mturner@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Olivia Baker', 'Line Production', '555-1258', 'obaker@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Tyler Johnson', 'Line Production', '555-1259', 'tjohnson@email.com');

INSERT INTO employees_t(employee_name, employee_position_name, employee_phone, employee_email)
    VALUES('Emma Harris', 'Line Production', '555-1260', 'eharris@email.com');

-- insert employee timeclock data

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(1, '2023', 520, 580, 600, 500);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(2, '2023', 520, 560, 600, 520);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(3, '2023', 500, 520, 515, 525);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(4, '2023', 520, 520, 520, 520);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(5, '2023', 490, 420, 390, 500);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(6, '2023', 600, 590, 610, 590);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(7, '2023', 500, 490, 510, 480);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(8, '2023', 510, 560, 590, 530);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(9, '2023', 490, 570, 620, 500);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(10, '2023', 480, 550, 600, 510);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(11, '2023', 500, 590, 630, 480);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(12, '2023', 510, 560, 610, 520);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(13, '2023', 520, 570, 590, 550);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(14, '2023', 530, 580, 600, 530);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(15, '2023', 490, 550, 610, 490);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(16, '2023', 510, 580, 590, 530);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(17, '2023', 490, 560, 620, 500);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(18, '2023', 480, 570, 600, 510);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(19, '2023', 500, 590, 630, 480);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(20, '2023', 510, 560, 610, 520);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(21, '2023', 520, 570, 590, 550);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(22, '2023', 500, 540, 600, 530);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(23, '2023', 520, 580, 610, 490);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(24, '2023', 510, 560, 590, 530);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(25, '2023', 490, 570, 620, 500);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(26, '2023', 480, 550, 600, 510);

INSERT INTO timeclock_quarterly_t(employee_id, timeclock_year, quarter_1_hours, quarter_2_hours, quarter_3_hours, quarter_4_hours)
    VALUES(27, '2023', 510, 590, 630, 480);


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

-- Insert Supply Inventory Orders

INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(1, 200, '2023-01-05', '2023-01-07', '2023-01-14', '2023-01-12');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(5, 1, '2023-01-15', '2023-01-20', '2023-02-01', '2023-02-06');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(2, 369, '2023-02-15', '2023-02-18', '2023-02-25', '2023-03-02');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(6, 11, '2023-02-20', '2023-02-25', '2023-03-10', '2023-03-13');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(4, 41, '2023-03-22', '2023-03-28', '2023-04-10', '2023-04-17');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(1, 462, '2023-04-05', '2023-04-08', '2023-04-20', '2023-04-27');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(3, 51, '2023-05-07', '2023-05-11', '2023-05-23', '2023-05-28');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(4, 27, '2023-05-17', '2023-05-21', '2023-06-02', '2023-06-09');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(6, 2, '2023-06-14', '2023-06-21', '2023-07-05', '2023-07-12');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(3, 38, '2023-07-07', '2023-07-10', '2023-07-24', '2023-07-29');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(5, 1, '2023-08-02', '2023-08-07', '2023-08-19', '2023-08-26');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(2, 491, '2023-09-10', '2023-09-15', '2023-09-27', '2023-10-02');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(1, 234, '2023-10-22', '2023-10-26', '2023-11-06', '2023-11-11');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(3, 68, '2023-12-01', '2023-12-05', '2023-12-18', '2023-12-23');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(4, 64, '2023-12-16', '2023-12-20', '2024-01-02', '2024-01-09');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(1, 321, '2023-01-25', '2023-01-28', '2023-02-09', '2023-02-14');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(5, 1, '2023-09-25', '2023-09-28', '2023-10-10', '2023-10-17');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(6, 5, '2023-11-05', '2023-11-09', '2023-11-21', '2023-11-28');
INSERT INTO supply_orders_t(supply_id, quantity, order_date, order_shipdate, order_expecteddate, order_arrivaldate)
    VALUES(2, 477, '2023-03-05', '2023-03-09', '2023-03-21', '2023-03-28');

-- insert order records

INSERT INTO order_distribution_t(order_date, order_shipdate, order_arrivaldate, distribution_id)
    VALUES('2023-04-11', '2023-4-15', '2023-04-29', 1);

INSERT INTO order_distribution_t(order_date, order_shipdate, order_arrivaldate, distribution_id)
    VALUES('2023-12-15', '2023-12-20', '2023-12-31', 2);

INSERT INTO order_distribution_t(order_date, order_shipdate, order_arrivaldate, distribution_id)
    VALUES('2023-01-22', '2023-1-24', '2023-01-29', 3);

INSERT INTO order_distribution_t(order_date, order_shipdate, order_arrivaldate, distribution_id)
    VALUES('2023-12-20', '2023-12-23', '2023-12-29', 4);

INSERT INTO order_distribution_t(order_date, order_shipdate, order_arrivaldate, distribution_id)
    VALUES('2023-03-23', '2023-12-27', '2023-03-30', 5);

INSERT INTO order_distribution_t(order_date, order_shipdate, order_arrivaldate, distribution_id)
    VALUES('2023-06-12', '2023-06-21', '2023-06-30', 6);

-- insert order details

INSERT INTO order_distribution_details_t (order_distribution_id, product_id, quantity, subtotal_cost)
    VALUES(2, 2, 300, 22497);

INSERT INTO order_distribution_details_t (order_distribution_id, product_id, quantity, subtotal_cost)
    VALUES(1, 3, 400, 51996);

INSERT INTO order_distribution_details_t (order_distribution_id, product_id, quantity, subtotal_cost)
    VALUES(3, 6, 200, 19998);

INSERT INTO order_distribution_details_t (order_distribution_id, product_id, quantity, subtotal_cost)
    VALUES(6, 1, 100, 8999);

INSERT INTO order_distribution_details_t (order_distribution_id, product_id, quantity, subtotal_cost)
    VALUES(4, 4, 300, 20997);

INSERT INTO order_distribution_details_t (order_distribution_id, product_id, quantity, subtotal_cost)
    VALUES(5, 5, 200, 27998);