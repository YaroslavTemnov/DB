-- Narkevich Yaroslav 25B030221

CREATE DATABASE Lab5;

--TASK 1.1
CREATE TABLE employees(
    employee_id INT,
    first_name TEXT,
    last_name TEXT,
    age INT CHECK(age BETWEEN 18 AND 65),
    salary NUMERIC CHECK(salary > 0)
);

--TASK 1.2
CREATE TABLE products_catalog(
    product_id INT,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CHECK(regular_price > 0
              AND discount_price > 0
              AND discount_price < regular_price)
);

--TASK1.3
CREATE TABLE bookings(
    booking_id INT,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INT,
    CHECK(num_guests BETWEEN 1 AND 10
              AND check_out_date > check_in_date)
);

--TASK 1.4
INSERT INTO employees VALUES (1, 'Khalid', 'Kashimiri',20, 20000),
                             (2, 'Marcus', 'Persson', 35, 30000);

--INSERT INTO employees VALUES (3, 'Thomas', 'Astruc',67, 20000);
-- This will cause an error because age is not between 18 and 65, so the CHECK is working

INSERT INTO products_catalog VALUES (1, 'Spinner', 10,8),
                             (2, '3D-pen', 20, 16);

--INSERT INTO products_catalog VALUES (3, 'Spinner', 10,12);
--this will cause an error because discount_price is greater than regular price, so the CHECK is working

INSERT INTO bookings VALUES (1, '2020-10-12', '2020-12-10'),
                            (2, '2000-09-10', '2006-01-07');

--INSERT INTO bookings VALUES (3, '2026-10-13', '2026-10-10');
--this will cause an error because check_out_date is earlier than check_in_date

--TASK 2.1
CREATE TABLE costumers(
    costumer_id INT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

--TASK 2.2
CREATE TABLE inventory(
    item_id INT NOT NULL ,
    item_name TEXT NOT NULL,
    quantity INT NOT NULL CHECK(quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK(unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

--TASK 2.3
INSERT INTO costumers VALUES (1, 'NarutoUzumaki@Hokage.Konoha', '+67', '2020-10-20');

--INSERT INTO costumers VALUES (2, NULL, 'Someonesemail@email.com', NULL);
-- this will cause an error because some values that must NOT NULL are nulls

INSERT INTO inventory VALUES (1, 'Spinner', 1, 8, '2023-03-10');

--INSERT INTO inventory VALUES (2, NULL, -1, NULL, '2023-03-10');
--this will cause an error because of null numbers and some check conditions are not true

--TASK 3.1
CREATE TABLE users(
    user_id INT,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);

--TASK 3.2
CREATE TABLE course_enrollments(
    enrollment_id INT,
    student_id INT,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);

--TASK 3.3

INSERT INTO users VALUES (1, '7_Hokage_Dattebayo', 'NarutoUzumaki@Hokage.Konoha');

-- INSERT INTO users VALUES (2, 'LastUchiha', 'NarutoUzumaki@Hokage.Konoha');
-- this will cause an error because this insert have same email as first

INSERT INTO course_enrollments VALUES (1, 3, 2, 1);

-- INSERT INTO course_enrollments VALUES (2, 3, 2, 1);
-- this wil cause an error because this insert is same as previous (student_id, course_code and semester columns are the same

--TASK 4.1

CREATE TABLE departments(
    dept_id INT PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments VALUES (1, 'IT', 'Tole BI st. 59');
INSERT INTO departments VALUES (2, 'Finance', 'Vishnevaya st. 6');
INSERT INTO departments VALUES (3, 'management', 'Gogol st. 17');

-- INSERT INTO departments VALUES (2, 'IT', 'Kazybek Bi st. 22');
-- it will cause an error because primary key value is unique and cannot be repeated

-- INSERT INTO departments VALUES (NULL, 'somedepartment', 'someadress');
-- it will cause an error because PRIMARY KEY cannot be NULL

-- TASK 4.2

CREATE TABLE student_courses(
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

-- Task 4.3
--1)
-- PRIMARY KEY makes every row unique. Cannot be a Null. Only one in table (may be a set of columns)
-- Unique Constraint to insert repeating values. Can be a null. May be many in one table
--2)
-- Single column as a Primary Key is used when there is an one column that can make every row unique like id
-- Multiple columns as a Primary Key is used when there is no one columns that can make every row unique, or the table is transitive
--3)
-- Because if there are more than one primary key the table will have uncertanties between different primary keys
-- Unique can be multiple because it just constraint and it won't make any unsertainties between rows

-- Task 5.1
CREATE TABLE employees_dept(
    emp_id INT PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INT REFERENCES departments,
    hire_date DATE
);

INSERT INTO employees_dept VALUES (1, 'Someump', 1);

--INSERT INTO employees_dept VALUES (2, 'Anotheroneemployee', 10);
-- it will cause an error because there is no any department with id 10

-- Task 5.2
CREATE TABLE authors(
    author_id INT PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers(
    publisher_id INT PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books(
    book_id INT PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INT REFERENCES authors,
    publisher_id INT REFERENCES publishers,
    publication_year INT,
    isbn TEXT UNIQUE
);

INSERT INTO authors (author_id, author_name, country) VALUES
(1, 'George Orwell', 'United Kingdom'),
(2, 'J.K. Rowling', 'United Kingdom'),
(3, 'Ernest Hemingway', 'United States');

INSERT INTO publishers (publisher_id, publisher_name, city) VALUES
(1, 'Penguin Books', 'London'),
(2, 'Bloomsbury Publishing', 'London'),
(3, 'Charles Scribner''s Sons', 'New York');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn) VALUES
(101, '1984', 1, 1, 1949, '978-0451524935'),
(102, 'Harry Potter and the Philosopher''s Stone', 2, 2, 1997, '978-0747532699'),
(103, 'The Old Man and the Sea', 3, 3, 1952, '978-0684801223');

CREATE TABLE categories(
    category_id INT PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk(
    product_id INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INT REFERENCES categories ON DELETE CASCADE
);

CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items(
    item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders ON DELETE CASCADE,
    product_id INT REFERENCES products_fk,
    quantity INT CHECK(quantity > 0)
);


INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing');

INSERT INTO products_fk (product_id, product_name, category_id) VALUES
(10, 'Smartphone', 1),
(20, 'SQL Guidebook', 2),
(30, 'T-Shirt', 3);

INSERT INTO orders (order_id, order_date) VALUES
(1001, '2026-10-10'),
(1002, '2026-10-11'),
(1003, '2026-10-12');

INSERT INTO order_items (item_id, order_id, product_id, quantity) VALUES
(1, 1001, 10, 1),
(2, 1002, 20, 2),
(3, 1003, 30, 3);

-- DELETE FROM categories WHERE category_id = 1;
-- it will cause an error because there is rows in table order_items that depend on category table

DELETE
FROM orders
WHERE order_id = 1;

-- it won't cause an error because order_id is ON DELETE CASCADE and all related rows in other tables will be deleted automatically

-- TASK 6.1
CREATE DATABASE E_commerce;
-- in E_commerce console
CREATE TABLE costumers(
    costumer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT NOT NULL,
    registration_date DATE
);

CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price INT NOT NULL CHECK(price > 0),
    stock_quantity INT NOT NULL CHECK(stock_quantity >= 0)
);

CREATE TABLE orders(
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers,
    order_date DATE NOT NULL,
    total_amount INT NOT NULL CHECK(total_amount > 0),
    status TEXT CHECK( status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_details(
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders,
    product_id INT REFERENCES products,
    quantity INT CHECK(quantity > 0),
    unit_price INT CHECK(unit_price > 0)
);

INSERT INTO costumers (costumer_id, name, email, phone, registration_date) VALUES
(1, 'Alice Smith', 'alice.smith@example.com', '+12345678901', '2026-01-15'),
(2, 'Bob Jones', 'bob.jones@example.com', '+12345678902', '2026-02-20'),
(3, 'Charlie Brown', 'charlie.b@example.com', '+12345678903', '2026-03-10'),
(4, 'Diana Prince', 'diana.prince@example.com', '+12345678904', '2026-04-05'),
(5, 'Evan Wright', 'evan.wright@example.com', '+12345678905', '2026-05-12');


INSERT INTO products (product_id, name, description, price, stock_quantity) VALUES
(101, 'Wireless Mouse', 'Ergonomic wireless optical mouse', 25.50, 150),
(102, 'Mechanical Keyboard', 'RGB backlit mechanical keyboard', 79.99, 80),
(103, '27-inch Monitor', '4K UHD IPS gaming monitor', 299.99, 30),
(104, 'USB-C Hub', 'Multiport adapter with HDMI and USB 3.0', 45.00, 200),
(105, 'Bluetooth Headphones', 'Active noise-cancelling over-ear headphones', 120.00, 60);


INSERT INTO orders (order_id, customer_id, order_date, total_amount, status) VALUES
(1001, 1, '2026-10-01', 105.49, 'delivered'),
(1002, 2, '2026-10-05', 299.99, 'shipped'),
(1003, 3, '2026-10-08', 45.00, 'processing'),
(1004, 1, '2026-10-10', 120.00, 'pending'),
(1005, 4, '2026-10-12', 79.99, 'cancelled');


INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1001, 101, 1, 25.50),
(2, 1001, 102, 1, 79.99),
(3, 1002, 103, 1, 299.99),
(4, 1003, 104, 1, 45.00),
(5, 1004, 105, 1, 120.00);

-- INSERT INTO costumers VALUES (6, 'AliceFake', 'alice.smith@example.com', '+6767667', '2026-01-15');
-- it will cause an error because email is repeating

--INSERT INTO products VALUES (6, NULL, 'SMTH', 10000, 200);
-- it will cause an error because name cannot be a NULL

--INSERT INTO orders VALUES (6, 1, '2000-01-01', 2, 'delivering');
-- it will not work because of check condition

--INSERT INTO order_details VALUES (1, 10, 2, -1, 2);
--it will cause an errors because: repeated ID, there is no order with id 10, price is less than 0