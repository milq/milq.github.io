DROP DATABASE IF EXISTS dwes_to4_balance;
CREATE DATABASE dwes_to4_balance;
USE dwes_to4_balance;

CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(10) NOT NULL CHECK (type IN ('income', 'expense')),
    amount DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL
);
