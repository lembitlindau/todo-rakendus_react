-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Jan 16, 2025 at 12:33 PM
-- Server version: 10.11.10-MariaDB-ubu2204
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bus_schedule`
--

-- --------------------------------------------------------

--
-- Table structure for table `departures`
--

CREATE TABLE `departures` (
  `id` int(10) UNSIGNED NOT NULL,
  `stop_id` int(10) UNSIGNED NOT NULL,
  `departure_time` time NOT NULL,
  `day_of_week` tinyint(3) UNSIGNED NOT NULL COMMENT '0=Sunday, 1=Monday, ..., 6=Saturday'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departures`
--

INSERT INTO `departures` (`id`, `stop_id`, `departure_time`, `day_of_week`) VALUES
(1, 1, '07:00:00', 1),
(2, 1, '08:30:00', 1),
(3, 2, '07:30:00', 1),
(4, 2, '09:00:00', 1),
(5, 1, '07:00:00', 2),
(6, 1, '08:30:00', 2),
(7, 2, '07:30:00', 2),
(8, 2, '09:00:00', 2);

--
-- Triggers `departures`
--
DELIMITER $$
CREATE TRIGGER `after_departures_update` AFTER UPDATE ON `departures` FOR EACH ROW BEGIN
    INSERT INTO departures_log (departure_id, old_departure_time, new_departure_time)
    VALUES (OLD.id, OLD.departure_time, NEW.departure_time);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_departure_insert` BEFORE INSERT ON `departures` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1
        FROM departures
        WHERE stop_id = NEW.stop_id
          AND departure_time = NEW.departure_time
          AND day_of_week = NEW.day_of_week
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate departure time for the same stop is not allowed';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_arrival_times` BEFORE INSERT ON `departures` FOR EACH ROW BEGIN
    DECLARE prev_stop_time TIME;
    
    -- Get departure time of previous stop in sequence
    SELECT d.departure_time INTO prev_stop_time
    FROM departures d
    JOIN stops s1 ON d.stop_id = s1.id
    JOIN stops s2 ON NEW.stop_id = s2.id
    WHERE s1.sequence_number < s2.sequence_number
    AND d.day_of_week = NEW.day_of_week
    ORDER BY s1.sequence_number DESC
    LIMIT 1;
    
    IF prev_stop_time IS NOT NULL AND NEW.departure_time <= prev_stop_time THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Arrival time must be later than previous stop!';
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `departures`
--
ALTER TABLE `departures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stop_id` (`stop_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `departures`
--
ALTER TABLE `departures`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `departures`
--
ALTER TABLE `departures`
  ADD CONSTRAINT `departures_ibfk_1` FOREIGN KEY (`stop_id`) REFERENCES `stops` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
