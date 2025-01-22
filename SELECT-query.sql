-- Lisa stops tabel
CREATE TABLE `stops` (
                         `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
                         `name` varchar(255) NOT NULL,
                         `location` varchar(255) DEFAULT NULL,
                         PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Lisa andmed stops tabelisse
INSERT INTO `stops` (`id`, `name`, `location`) VALUES
                                                   (1, 'Lehmja', 'Keskus'),
                                                   (2, 'Tornimäe', 'Mäe tänav');

-- Täienda departures tabelit, et kasutada stops tabelit
ALTER TABLE `departures`
    ADD CONSTRAINT `departures_ibfk_1` FOREIGN KEY (`stop_id`) REFERENCES `stops` (`id`) ON DELETE CASCADE;

-- Lisa SELECT-päringu näide
-- Liida stops ja departures tabelid, et näha väljumisaegu ja peatusi
SELECT
    stops.name AS stop_name,
    stops.location AS stop_location,
    departures.departure_time,
    departures.day_of_week
FROM stops
         INNER JOIN departures ON stops.id = departures.stop_id
WHERE departures.day_of_week = 1 -- Esmaspäeva väljumised
ORDER BY departures.departure_time ASC;
