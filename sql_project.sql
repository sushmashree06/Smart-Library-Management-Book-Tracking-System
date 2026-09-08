CREATE DATABASE smart_library;
USE smart_library;

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    country VARCHAR(50)
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    member_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    join_date DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    published_year YEAR,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'Borrowed',
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    reservation_date DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO categories (category_name) VALUES
('Fiction'), ('Technology'), ('Science'), ('History'), ('Self Help');

INSERT INTO authors (author_name, email, country) VALUES
('George Orwell', 'orwell@email.com', 'United Kingdom'),
('Robert C. Martin', 'martin@email.com', 'USA'),
('Stephen Hawking', 'hawking@email.com', 'United Kingdom'),
('J. K. Rowling', 'rowling@email.com', 'United Kingdom'),
('James Clear', 'clear@email.com', 'USA');

INSERT INTO members (member_name, email, phone, join_date, status) VALUES
('Varshika', 'varshika@gmail.com', '9876543210', '2026-08-01', 'Active'),
('Sushma', 'sushma@gmail.com', '9876543211', '2026-08-02', 'Active'),
('Praneetha', 'praneetha@gmail.com', '9876543212', '2026-08-03', 'Active'),
('Rahul', 'rahul@gmail.com', '9876543213', '2026-08-04', 'Active'),
('Anjali', 'anjali@gmail.com', '9876543214', '2026-08-05', 'Inactive');

INSERT INTO books (title, author_id, category_id, isbn, total_copies, available_copies, published_year) VALUES
('1984', 1, 1, 'ISBN001', 5, 4, 1949),
('Clean Code', 2, 2, 'ISBN002', 4, 3, 2008),
('A Brief History of Time', 3, 3, 'ISBN003', 3, 2, 1988),
('Harry Potter', 4, 1, 'ISBN004', 6, 5, 1997),
('Atomic Habits', 5, 5, 'ISBN005', 5, 5, 2018),
('Animal Farm', 1, 1, 'ISBN006', 2, 2, 1945);

INSERT INTO borrowings (member_id, book_id, borrow_date, due_date, return_date, status) VALUES
(1, 1, '2026-08-10', '2026-08-24', '2026-08-20', 'Returned'),
(2, 2, '2026-08-15', '2026-08-29', NULL, 'Borrowed'),
(3, 3, '2026-08-18', '2026-09-01', NULL, 'Borrowed'),
(1, 4, '2026-08-25', '2026-09-08', NULL, 'Borrowed'),
(4, 1, '2026-08-05', '2026-08-19', '2026-08-18', 'Returned');


INSERT INTO reservations (member_id, book_id, reservation_date, status) VALUES
(5, 2, '2026-09-01', 'Pending'),
(3, 5, '2026-09-02', 'Completed');

SELECT * FROM books;
SELECT * FROM members;

SELECT title, available_copies
FROM books
WHERE available_copies > 0;

SELECT *
FROM members
WHERE status = 'Active';

SELECT *
FROM books
ORDER BY title ASC;

SELECT category_id, COUNT(*) AS total_books
FROM books
GROUP BY category_id;

SELECT category_id, COUNT(*) AS total_books
FROM books
GROUP BY category_id
HAVING COUNT(*) >= 2;

SELECT COUNT(*) AS total_books FROM books;

SELECT SUM(total_copies) AS total_copies FROM books;

SELECT AVG(total_copies) AS average_copies FROM books;

SELECT MIN(published_year) AS oldest_book,
       MAX(published_year) AS newest_book
FROM books;

SELECT b.title, a.author_name, c.category_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
INNER JOIN categories c ON b.category_id = c.category_id;

SELECT m.member_name, b.title, br.borrow_date, br.status
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
LEFT JOIN books b ON br.book_id = b.book_id;

SELECT b.title, br.borrowing_id, br.status
FROM borrowings br
RIGHT JOIN books b ON br.book_id = b.book_id;


SELECT title
FROM books
WHERE book_id IN (
    SELECT book_id
    FROM borrowings
    WHERE status = 'Borrowed'
);

SELECT member_name
FROM members
WHERE member_id IN (
    SELECT member_id
    FROM borrowings
    GROUP BY member_id
    HAVING COUNT(*) > 1
);

SELECT title
FROM books
WHERE available_copies > (
    SELECT AVG(available_copies)
    FROM books
);

CREATE OR REPLACE VIEW available_books_view AS
SELECT book_id, title, available_copies
FROM books
WHERE available_copies > 0;

CREATE OR REPLACE VIEW member_borrowing_view AS
SELECT m.member_name, b.title, br.borrow_date, br.due_date,
       br.return_date, br.status
FROM borrowings br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id;

SELECT title
FROM books
WHERE book_id IN (
    SELECT book_id
    FROM borrowings
    WHERE status = 'Borrowed'
);

SELECT member_name
FROM members
WHERE member_id IN (
    SELECT member_id
    FROM borrowings
    GROUP BY member_id
    HAVING COUNT(*) > 1
);

SELECT title
FROM books
WHERE available_copies > (
    SELECT AVG(available_copies)
    FROM books
);

CREATE OR REPLACE VIEW available_books_view AS
SELECT book_id, title, available_copies
FROM books
WHERE available_copies > 0;

CREATE OR REPLACE VIEW member_borrowing_view AS
SELECT m.member_name, b.title, br.borrow_date, br.due_date,
       br.return_date, br.status
FROM borrowings br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id;

SELECT * FROM available_books_view;
SELECT * FROM member_borrowing_view;

DELIMITER //
CREATE PROCEDURE BorrowBook(
    IN p_member_id INT,
    IN p_book_id INT
)
BEGIN
    DECLARE copies INT;

    SELECT available_copies INTO copies
    FROM books
    WHERE book_id = p_book_id;

    IF copies > 0 THEN
        INSERT INTO borrowings
            (member_id, book_id, issue_date, due_date, status)
        VALUES
            (p_member_id, p_book_id, CURDATE(),
             DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Borrowed');
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book is not available';
    END IF;
END //

DELIMITER ;
CALL GetAvailableBooks();


DELIMITER //
CREATE FUNCTION GetAvailableCopies(p_book_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE copies INT;

    SELECT available_copies INTO copies
    FROM books
    WHERE book_id = p_book_id;

    RETURN copies;
END //


DELIMITER //
CREATE FUNCTION CalculateBorrowDays(
    p_borrow_date DATE,
    p_return_date DATE
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(p_return_date, p_borrow_date);
END //

DELIMITER ;

SELECT GetAvailableCopies(1) AS available_copies;

SELECT CalculateBorrowDays(
    '2026-08-10',
    '2026-08-20'
) AS days_used;

DELIMITER //
CREATE TRIGGER after_borrow_insert
AFTER INSERT ON borrowings
FOR EACH ROW
BEGIN
    IF NEW.status = 'Borrowed' THEN
        UPDATE books
        SET available_copies = available_copies - 1
        WHERE book_id = NEW.book_id
          AND available_copies > 0;
    END IF;
END //

DELIMITER //
CREATE TRIGGER after_book_return
AFTER UPDATE ON borrowings
FOR EACH ROW
BEGIN
    IF OLD.status = 'Borrowed'
       AND NEW.status = 'Returned' THEN
        UPDATE books
        SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;
    END IF;
END //
DELIMITER ;

START TRANSACTION;

UPDATE members
SET status = 'Inactive'
WHERE member_id = 5;

SAVEPOINT member_update;

UPDATE members
SET status = 'Active'
WHERE member_id = 5;

ROLLBACK TO member_update;


CREATE INDEX idx_book_title
ON books(title);

CREATE INDEX idx_member_name
ON members(member_name);

CREATE INDEX idx_borrow_status
ON borrowings(status);

-- Total number of books
SELECT COUNT(*) AS total_books
FROM books;

-- Total registered members
SELECT COUNT(*) AS total_members
FROM members;

-- Currently borrowed books
SELECT COUNT(*) AS currently_borrowed
FROM borrowings
WHERE status = 'Borrowed';

-- Available books
SELECT title, available_copies
FROM books
WHERE available_copies > 0;

-- Borrowing history
SELECT *
FROM member_borrowing_view;

-- Books grouped by category
SELECT c.category_name,
       COUNT(b.book_id) AS total_books
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name;

-- Most frequently borrowed books
SELECT b.title,
       COUNT(br.borrowing_id) AS borrow_count
FROM books b
LEFT JOIN borrowings br ON b.book_id = br.book_id
GROUP BY b.book_id, b.title
ORDER BY borrow_count DESC;

-- Member-wise borrowing details
SELECT m.member_name,
       COUNT(br.borrowing_id) AS total_borrowings
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id, m.member_name
ORDER BY total_borrowings DESC;


-- DML Examples
UPDATE books
SET available_copies = 5
WHERE book_id = 5;

DELETE FROM reservations
WHERE reservation_id IN (1,2,3)
AND status = 'Completed';

-- TCL Examples
START TRANSACTION;

UPDATE books
SET total_copies = total_copies + 1
WHERE book_id = 1;

COMMIT;

