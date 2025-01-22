-- Alusta transaktsiooni
START TRANSACTION;

-- Proovi lisada uus väljumisaeg
-- Esimene operatsioon: Lisa uus väljumisaeg tabelisse `departures`
INSERT INTO departures (stop_id, departure_time, day_of_week) VALUES (1, '12:00:00', 1);

-- Teine operatsioon: Lisa samaaegselt logikirje
INSERT INTO departures_log (departure_id, old_departure_time, new_departure_time)
VALUES (LAST_INSERT_ID(), NULL, '12:00:00');

-- Jõustame veatingimuse: Duplikaat väljumise lisamine
-- Kui see operatsioon ebaõnnestub, peaks transaktsioon tagasi pöörduma
INSERT INTO departures (stop_id, departure_time, day_of_week) VALUES (1, '12:00:00', 1);

-- Kui kõik operatsioonid õnnestuvad, pühenda muudatused
COMMIT;

-- Kui mõni operatsioon ebaõnnestub, tagasta muudatused
ROLLBACK;


Eduka ja ebaõnnestunud stsenaariumi näide

Edukas stsenaarium
Kui lisatav väljumisaeg ei ole duplikaat, näeb päringute järjestus välja järgmine:

INSERT INTO departures õnnestub.
INSERT INTO departures_log õnnestub.
COMMIT pühendab muudatused.

Ebaõnnestunud stsenaarium
Kui lisatav väljumisaeg on juba olemas:

Esimene INSERT INTO departures õnnestub.
INSERT INTO departures_log õnnestub.
Teine INSERT INTO departures ebaõnnestub.
ROLLBACK tühistab kõik muudatused