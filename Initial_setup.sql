/*
The following is the code for the schema setup for my tasks. All my tasks and sections will be split up into different files
*/

CREATE DATABASE IF NOT EXISTS revzone;

USE revzone;

CREATE TABLE bikes (
    bike_id     INT PRIMARY KEY,
    brand       VARCHAR(50),
    model       VARCHAR(100),
    type        VARCHAR(50),
    engine_cc   INT,
    price_inr   INT,
    year        INT,
    in_stock    BOOLEAN
);

CREATE TABLE customers (
    customer_id  INT PRIMARY KEY,
    name         VARCHAR(100),
    city         VARCHAR(50),
    age          INT,
    member_since DATE
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    bike_id     INT,
    order_date  DATE,
    quantity    INT,
    discount    DECIMAL(5,2)
);

INSERT INTO bikes VALUES
(1,  'Royal Enfield', 'Classic 350',        'Cruiser',   349,  192000, 2022, TRUE),
(2,  'Royal Enfield', 'Himalayan',           'Adventure', 411,  229000, 2023, TRUE),
(3,  'KTM',           '390 Duke',            'Naked',     373,  311000, 2023, TRUE),
(4,  'KTM',           '250 Duke',            'Naked',     248,  233000, 2022, TRUE),
(5,  'Bajaj',         'Dominar 400',         'Sport',     373,  231000, 2022, TRUE),
(6,  'Honda',         'CB300R',              'Naked',     286,  263000, 2023, FALSE),
(7,  'Honda',         'Africa Twin',         'Adventure', 1084, 1610000,2023, TRUE),
(8,  'Yamaha',        'MT-15',               'Naked',     155,  163000, 2022, TRUE),
(9,  'Yamaha',        'R15 V4',              'Sport',     155,  181000, 2023, TRUE),
(10, 'Suzuki',        'V-Strom 650',         'Adventure', 645,  896000, 2022, FALSE),
(11, 'Kawasaki',      'Z650',                'Naked',     649,  637000, 2023, TRUE),
(12, 'Kawasaki',      'Ninja 650',           'Sport',     649,  731000, 2022, TRUE),
(13, 'Royal Enfield', 'Interceptor 650',     'Cruiser',   648,  303000, 2023, TRUE),
(14, 'Triumph',       'Speed 400',           'Naked',     398,  230000, 2023, TRUE),
(15, 'Bajaj',         'Pulsar NS200',        'Naked',     199,  142000, 2022, TRUE),
(16, 'TVS',           'Apache RR 310',       'Sport',     312,  272000, 2023, FALSE),
(17, 'TVS',           'Ronin',               'Naked',     225,  148000, 2022, TRUE),
(18, 'Honda',         'Hornet 2.0',          'Naked',     184,  141000, 2023, TRUE),
(19, 'Royal Enfield', 'Super Meteor 650',    'Cruiser',   648,  393000, 2023, TRUE),
(20, 'KTM',           '890 Adventure',       'Adventure', 889,  1490000,2022, FALSE);

INSERT INTO customers VALUES
(1,  'Arjun Mehta',    'Mumbai',    28, '2021-03-15'),
(2,  'Priya Sharma',   'Delhi',     34, '2020-07-22'),
(3,  'Rohit Verma',    'Bangalore', 26, '2022-01-10'),
(4,  'Sneha Iyer',     'Chennai',   31, '2021-11-05'),
(5,  'Karan Joshi',    'Pune',      29, '2023-02-18'),
(6,  'Divya Nair',     'Hyderabad', 27, '2022-08-30'),
(7,  'Amit Patel',     'Ahmedabad', 35, '2020-05-12'),
(8,  'Neha Gupta',     'Kolkata',   30, '2021-09-25'),
(9,  'Vikram Singh',   'Jaipur',    33, '2023-04-07'),
(10, 'Ananya Das',     'Bangalore', 25, '2022-12-19');

INSERT INTO orders VALUES
(1,  3,  3,  '2023-06-01', 1, 0.00),
(2,  1,  13, '2023-06-15', 1, 5.00),
(3,  7,  7,  '2023-07-03', 1, 0.00),
(4,  2,  12, '2023-07-20', 1, 3.00),
(5,  5,  14, '2023-08-11', 1, 0.00),
(6,  8,  1,  '2023-08-25', 1, 2.50),
(7,  4,  9,  '2023-09-04', 1, 0.00),
(8,  6,  8,  '2023-09-18', 2, 0.00),
(9,  10, 5,  '2023-10-02', 1, 4.00),
(10, 9,  11, '2023-10-30', 1, 0.00),
(11, 1,  2,  '2023-11-12', 1, 5.00),
(12, 3,  15, '2023-11-28', 1, 0.00),
(13, 2,  19, '2023-12-05', 1, 3.50),
(14, 7,  20, '2023-12-18', 1, 0.00),
(15, 5,  6,  '2024-01-09', 1, 0.00);

INSERT INTO bikes VALUES (21, 'Harley-Davidson', 'X440', 'Cruiser', 440, NULL, 2023, TRUE);

INSERT INTO customers VALUES 
(11, 'Siddharth Roy', 'Kolkata', 24, '2024-01-15'),
(12, 'Meera Pillai',  'Kochi',   29, '2024-02-10');