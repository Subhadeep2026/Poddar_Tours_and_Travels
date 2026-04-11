-- Poddar Tours & Travels - Database Schema (MySQL)
-- Use this script to set up your local database tables.

-- 1. Create destinations table
CREATE TABLE IF NOT EXISTS destinations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    title VARCHAR(255),
    description TEXT,
    image_url VARCHAR(255),
    highlights TEXT, -- Can store as comma-separated or JSON
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create tour_packages table
CREATE TABLE IF NOT EXISTS tour_packages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    destination_id INT,
    package_name VARCHAR(255) NOT NULL,
    duration_days INT,
    base_price DECIMAL(10, 2),
    category VARCHAR(100), -- Retreat, Adventure, etc.
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE SET NULL
);

-- 3. Create journey_dates table
CREATE TABLE IF NOT EXISTS journey_dates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT,
    travel_month VARCHAR(50),
    start_day INT, -- The specific day of departure
    fare DECIMAL(10, 2),
    FOREIGN KEY (package_id) REFERENCES tour_packages(id) ON DELETE CASCADE
);

-- 4. Create inquiries table (Feedback & Contact Us)
CREATE TABLE IF NOT EXISTS inquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inquiry_type ENUM('FEEDBACK', 'CONTACT') NOT NULL,
    unique_ref_id VARCHAR(20) UNIQUE, -- e.g., FDB-1001
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(20),
    message TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Sample Data (Optional)
INSERT INTO destinations (name, title, description, image_url, highlights) VALUES 
('Kashmir', 'PARADISE ON EARTH', 'Serene valleys and snow-capped peaks.', 'img/KASHMIR.jpg', '✔ Houseboat Stay, ✔ Gondola Ride'),
('Kerala', 'GODS OWN COUNTRY', 'Peaceful backwaters and lush greenery.', 'img/Alleppey-Houseboats.jpeg', '✔ Tea Garden Visit, ✔ Backwater Cruise');

INSERT INTO tour_packages (destination_id, package_name, duration_days, base_price, category) VALUES 
(1, 'Kashmir Paradise', 8, 29795.00, 'Retreat'),
(2, 'Kerala Backwaters', 14, 30595.00, 'Nature');

INSERT INTO journey_dates (package_id, travel_month, start_day, fare) VALUES 
(1, 'February', 11, 29795.00),
(2, 'February', 27, 30595.00);
