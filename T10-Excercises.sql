-- T10
-- Relational Model -> SQL Model

/*
 Users (  userId, name, city, startDate)
    PK(userd), AK(naame)        #PK - primary key , AK - alternative key
 (AK - coś co mogłoby być PK ale nie jest XD)
Products (productId, description, price, stock)
    PK(productId)
Orders(orderId, userId, productId, amoount, purchaseDate)
    PK(orderId),
    FK(orderId)/User  (Foreign key - łączy się z OrderID które jesr w Order)
    FK(productId)/Products
ziana */

DROP TABLE IF EXISTs Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Users;
CREATE TABLE Users(
    userId INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(63) NOT NULL,
    city VARCHAR(63),
    startDate DATE NOT NULL,
    PRIMARY KEY (userId),
    CONSTRAINT RN_1b_nameUnique UNIQUE (NAME)
);

CREATE TABLE Products(
    productId INT NOT NULL AUTO_INCREMENT,
    description VARCHAR(12342) NOT NULL ,
    price DECIMAL(6,2) NOT NULL,
    stock INT,
    PRIMARY KEY (productId),
    CONSTRAINT RN_2b_price_range CHECK ( price >= 0 )
    -- CONSTRAINT RN_2c_positive_stock CHECK ( stock >= 0 )
);

CREATE TABLE Orders(
    orderId INT NOT NULL AUTO_INCREMENT,
    userId INT NOT NULL ,
    productId INT NOT NULL ,
    amount INT default (1),
    purchaseDate DATE DEFAULT (NOW()),
    PRIMARY KEY(orderId),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (productId) REFERENCES Products(productId),
    CONSTRAINT RN_3b_amount_range CHECK ( amount BETWEEN 0 and 10),
    CONSTRAINT RN_3c_month_Not_August CHECK ( MONTH(purchaseDate) <> 8  )
 );

/* User data */
INSERT INTO Users(name, city, startDate)
  	VALUES ('David Ruiz', 'Sevilla', '2018-05-18');
INSERT INTO Users(name, city, startDate)
	VALUES ('Marta López', 'London', '2018-06-12');
INSERT INTO Users(name, city, startDate)
	VALUES ('Raquel Lobato', 'Granada', '2018-12-01');
INSERT INTO Users(name, city, startDate)
	VALUES ('Antonio Gómez', 'Sevilla', '2018-03-11');
INSERT INTO Users(name, city, startDate)
	VALUES ('Inma Hernández', 'London', '2018-04-12');
INSERT INTO Users(name, city, startDate)
	VALUES ('Jimena Martín', 'Helsinki', '2018-05-13');
INSERT INTO Users(name, city, startDate)
	VALUES ('Carlos Rivero', 'Rochester', '2018-09-07');

/* Product data */
INSERT INTO Products(description, price, stock)
	VALUES('Motorola Razr 5G', 190.90, 50);
INSERT INTO Products(description, price, stock)
	VALUES('GoPro Hero 10 Black', 396.80, 20);
INSERT INTO Products(description, price, stock)
	VALUES('American Soft Linen Bath Towels', 15.90, 150);
INSERT INTO Products(description, price, stock)
	VALUES('Kasa Smart Plug HS103P4', 20.23, 25);
INSERT INTO Products(description, price, stock)
	VALUES('LEVOIT Air Purifiers for Home', 174.90, 50);
INSERT INTO Products(description, price, stock)
	VALUES('BISSELL Steam Shot', 27.40, 50);

/* Orders data */
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (1,1,2,'2019-05-13');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (1,3,2,'2019-05-13');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (2,2,3,'2019-06-11');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (2,3,1,'2019-06-11');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (3,4,2,'2019-06-15');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (4,5,1,'2019-06-18');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (4,6,1,'2019-06-18');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (5,4,2,'2019-12-15');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (7,1,1,'2019-12-15');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (7,2,1,'2019-12-16');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (7,3,1,'2019-12-17');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (7,4,1,'2019-12-18');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (7,5,1,'2019-12-19');
INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (7,6,1,'2019-12-20');


#SHOW Users form Sevilla
SELECT * FROM Users WHERE city = 'Sevilla';

CREATE OR REPLACE VIEW vSevillians AS
    SELECT * FROM Users WHERE city = 'Sevilla';

#show users from not sevilla
SELECT * FROM Users WHERE city != 'Sevilla';

CREATE OR REPLACE VIEW vNotSevillians AS
    SELECT * FROM Users WHERE city ^ 'Sevilla';

#Show users from Sevilla and london
SELECT * FROM Users WHERE city = 'Sevilla ' OR city = 'London';

#show names of the users from London and Sevilla
SELECT name FROM Users WHERE city = 'Sevilla' OR city = 'London';

#Show names of the users tht placed aan order, product,
#description, requested amount and total price od the order

#SHOW names of users that hve not placed any order
#SHOW name of the users who have ourchased every product
#SHOW names of the useers together with the total price of the product they ordered
#SHOW product description together with the total amount of orders
#SHOW a suummary of orders grouped by city (tota, avarage, max,min)
#SHOW summary of orders grouped by product (total, avarege, max, min)
#SHOW users that have spent more/less money
#show orders with the highest total price


/*
Scripts with the solutions to the proposed SQL exercises
Authors: Inma Hernández and David Ruiz
Creation date: October 2019
*/

/*
Load this script in HeidiSQL (File -> Load SQL script).
Use this script as a references of the expected results for each query
Bear in mind that there is not a unique solution for each exercise
(it is possible to retrieve the same results with different queries).
*/

/* Select the same DB that you used in the table generation and populate scripts*/

/* Users from Sevilla */
CREATE OR REPLACE VIEW vSevillians AS
SELECT *
FROM Users
WHERE city='Sevilla';

/* Users who are not from Sevilla*/
/* Option 1 */
CREATE OR REPLACE VIEW vNonSevillian AS
SELECT *
FROM Users
WHERE city <> 'Sevilla';

/* Option 2*/
CREATE OR REPLACE VIEW vNonSevillian AS
SELECT *
FROM Users
EXCEPT
SELECT *
FROM vSevillians;

/* Londoners and sevillians */
CREATE OR REPLACE VIEW vLondoners AS
SELECT *
FROM Users
WHERE city='London';

CREATE OR REPLACE VIEW vSevilliansLondoners AS
SELECT * FROM vSevillians
UNION
SELECT * FROM vLondoners;

/* Names of the users from Sevilla and London */
/* Option 1: */
CREATE OR REPLACE VIEW vNameSeviLondon AS
SELECT name FROM vSevilliansLondoners;
/* Option 2: */
CREATE OR REPLACE VIEW vNameSeviLondon AS
SELECT name
FROM users
WHERE city IN ('Sevilla', 'London');


/* NName of the users that placed an order, product description,
requested amount and total price of the order (in euros) */
CREATE OR REPLACE VIEW vFullOrders AS
SELECT U.name, P.description, O.amount, O.amount * P.price AS total
FROM Users U NATURAL JOIN
     Orders O NATURAL JOIN
	  Products P;

/* Names of the users that have not placed any order */
/* AllNames*/
CREATE OR REPLACE VIEW vAllNAmes AS
SELECT name FROM Users;

/* Names with orders*/
CREATE OR REPLACE VIEW vNamesWithOrders AS
SELECT DISTINCT name FROM Users NATURAL JOIN Orders NATURAL JOIN Products;

/* Names without orders */
CREATE OR REPLACE VIEW vNamesWithoutOrders AS
SELECT * from vAllNAmes except SELECT * from vNamesWithOrders;

/* Names of the users who have purchased every product  */

CREATE OR REPLACE VIEW vUPO AS
SELECT *
FROM Users U NATURAL JOIN
     Orders O NATURAL JOIN
	  Products P;

/* Option 2 (Inma) */
CREATE OR REPLACE VIEW vUsersLackingProducts AS
(SELECT NAME, productId FROM Users, Products
EXCEPT
SELECT NAME, productId FROM vUPO);

SELECT DISTINCT NAME FROM Users
EXCEPT
SELECT DISTINCT NAME FROM vUsersLackingProducts;

/* Option 3 (David) */
SELECT NAME, COUNT(*) numOrders
FROM vUPO
GROUP BY NAME
HAVING numOrders= (SELECT COUNT(*) FROM products);


/*Retrieve the name of the users together with the total price of the products they ordered*/
create or replace view vUsersTotalPrice  AS
SELECT name, sum(amount*price) priceOrders
FROM vUPO
GROUP BY NAME
ORDER BY priceOrders DESC;

/* Retrieve the product descriptions together with the total amount of orders that include them */
create or replace view VProductDescriptionNumOrders  AS
SELECT description, COUNT(orderId) amountOrders
FROM vUPO
GROUP BY description
ORDER BY amountOrders DESC;

/* Retrieve a summary of orders, grouped by city (total, average, max, min) */
/*
create or replace view vCityStat AS
SELECT province,
   COUNT(*) numOrders,
   AVG(amount) avgAmount,
   MAX(amount) maxAmount,
   MIN(amount) minAmount,
   SUM(amount) sumAmount,
   AVG(price) avgPrice,
   MAX(price) maxPrice,
   MIN(price) minPrice,
   SUM(price) sumPrice
FROM vupo
GROUP BY city
ORDER BY city ASC;

 */

/* Retrieve a summary of orders grouped by product (total, average, max, min)*/
create or replace view vOdersStat AS
SELECT description,
   COUNT(*) numOrders,
   AVG(amount) avgAmount,
   MAX(amount) maxAmount,
   MIN(amount) minAmount,
   SUM(amount) sumAmount,
   AVG(price) avgPrice,
   MAX(price) maxPrice,
   MIN(price) minPrice,
   SUM(price) sumPrice
FROM vupo
GROUP BY description
ORDER BY description  ASC;

/*Retrieve a summary of orders grouped by  users (total, average, max, min) */
/* create or replace view vUsersStat AS */
SELECT name,
   COUNT(*) numOrders,
   AVG(amount) avgAmount,
   MAX(amount) maxAmount,
   MIN(amount) minAmount,
   SUM(amount) sumAmount,
   AVG(price) avgPrice,
   MAX(price) maxPrice,
   MIN(price) minPrice,
   SUM(price) sumPrice
FROM vupo
GROUP BY name
ORDER BY name  ASC;

/*User(s) that have spent more/less money*/
/* Option 1*/

/* Order(s) with the highest/lowest total price */
/* These queries, just like the former, can be solved using different approaches, including
 <= ALL, >= ALL, and also ordering and using the LIMIT clause */
SELECT *
FROM vupo
WHERE amount * price = (SELECT MAX(amount*price) FROM vupo)
;

SELECT *
FROM vupo
WHERE amount * price = (SELECT MIN(amount*price) FROM vupo)
;

SELECT *
FROM users u, orders o, products p
WHERE u.userId = o.userId AND
      o.productId = p.productId AND
      amount * price = (SELECT MIN(amount*price) FROM vupo)
;
