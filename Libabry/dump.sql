CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ID igale kasutajale.',
    name VARCHAR(100) NOT NULL COMMENT 'Kasutaja täisnimi, piiratud 100 märgiga.',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Kasutaja e-posti aadress, peab olema unikaalne.',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Salasõna räsi turvaliseks autentimiseks.',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Konto loomise aeg.'
);

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ID igale autorile.',
    name VARCHAR(150) NOT NULL COMMENT 'Autori täisnimi, piiratud 150 märgiga.'
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ID igale kategooriale.',
    name VARCHAR(100) NOT NULL UNIQUE COMMENT 'Kategooria nimi, nt "Sci-Fi", peab olema unikaalne.'
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ID igale raamatule.',
    title VARCHAR(255) NOT NULL COMMENT 'Raamatu pealkiri, maksimaalselt 255 märki.',
    author_id INT NOT NULL COMMENT 'Viide autori ID-le.',
    category_id INT NOT NULL COMMENT 'Viide kategooria ID-le.',
    published_year YEAR COMMENT 'Raamatu ilmumisaasta.',
    available_copies INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Saadaolevate koopiate arv.',
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ID igale töötajale.',
    name VARCHAR(100) NOT NULL COMMENT 'Töötaja täisnimi.',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Töötaja e-posti aadress, peab olema unikaalne.',
    role ENUM('admin', 'librarian', 'assistant') NOT NULL COMMENT 'Töötaja roll raamatukogus.'
);

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ID igale laenutusele.',
    user_id INT NOT NULL COMMENT 'Viide kasutaja ID-le.',
    book_id INT NOT NULL COMMENT 'Viide laenutatud raamatu ID-le.',
    loan_date DATE NOT NULL COMMENT 'Laenutamise kuupäev.',
    return_date DATE COMMENT 'Tagastamise kuupäev, kui tagastatud.',
    returned BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Kas raamat on tagastatud või mitte.',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

CREATE TABLE returns (
    return_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unikaalne ID igale tagastusele.',
    loan_id INT NOT NULL UNIQUE COMMENT 'Viide laenutuse ID-le.',
    return_date DATE NOT NULL COMMENT 'Raamatu tegelik tagastamise kuupäev.',
    condition ENUM('good', 'damaged', 'lost') NOT NULL COMMENT 'Tagastatud raamatu seisukord.',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE
);
