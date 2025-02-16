
-- Utworzenie płatności dla subksrypcji
DELIMITER $$

CREATE PROCEDURE generuj_platnosci()
BEGIN
    DECLARE Done INT DEFAULT 0;
    DECLARE SubskrypcjaId INT;
    DECLARE DataRozpoczecia DATE;
    DECLARE DataZakonczenia DATE;
    DECLARE MetodaPlatnosci VARCHAR(20);
    DECLARE CursorSubskrypcji CURSOR FOR 
        SELECT id, data_rozpoczecia, COALESCE(data_zakonczenia, LAST_DAY(CURDATE()))
        FROM subskrypcja;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Done = 1;

    -- Funkcja losująca metodę płatności
    CREATE TEMPORARY TABLE IF NOT EXISTS MetodyPlatnosci (
        id INT PRIMARY KEY AUTO_INCREMENT,
        metoda VARCHAR(20)
    );

    -- Wypełniamy tabelę tymczasową metodami płatności
    INSERT IGNORE INTO MetodyPlatnosci (metoda)
    VALUES ('Karta'), ('Blik'), ('Przelew'), ('Gotowka');

    -- Otwieramy kursor dla subskrypcji
    OPEN CursorSubskrypcji;

    -- Iterujemy po każdej subskrypcji
    SubskrypcjeLoop: LOOP
        FETCH CursorSubskrypcji INTO SubskrypcjaId, DataRozpoczecia, DataZakonczenia;
        IF Done THEN
            LEAVE SubskrypcjeLoop;
        END IF;

        -- Sprawdźmy, czy dane są poprawne
        IF DataRozpoczecia IS NULL OR DataZakonczenia IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Niepoprawna data rozpoczęcia lub zakończenia dla subskrypcji';
        END IF;

        -- Wygeneruj płatności
        WHILE DataRozpoczecia <= DataZakonczenia DO
            -- Wybieramy losową metodę płatności
            SET MetodaPlatnosci = (SELECT metoda 
                                   FROM MetodyPlatnosci 
                                   ORDER BY RAND() 
                                   LIMIT 1);

            -- Dodaj wpis do tabeli platnosc
            INSERT IGNORE INTO platnosc (subskrypcja, data_zaplaty, metoda)
            VALUES (SubskrypcjaId, DataRozpoczecia, MetodaPlatnosci);

            -- Przejdź do kolejnego miesiąca
            SET DataRozpoczecia = DATE_ADD(DataRozpoczecia, INTERVAL 1 MONTH);
        END WHILE;
    END LOOP;

    -- Zamykamy kursor
    CLOSE CursorSubskrypcji;

    -- Usuwamy tabelę tymczasową
    DROP TEMPORARY TABLE IF EXISTS MetodyPlatnosci;
END$$

DELIMITER ;

call generuj_platnosci();

-- Usunięcie dostaw dla subskrypcji które są nieaktywne
DELETE dostawa
FROM dostawa
JOIN subskrypcja ON dostawa.subskrypcja = subskrypcja.id
WHERE subskrypcja.data_zakonczenia IS NOT NULL;

-- Usunięcie adresów dostaw dla subskrypcji które są nieaktywne
DELETE alergia
FROM alergia
JOIN subskrypcja ON alergia.subskrypcja = subskrypcja.id
WHERE subskrypcja.data_zakonczenia IS NOT NULL;

-- Usunięcie adresów dostaw dla subksrypcji które są nieaktywne
DELETE adres_dowozu
FROM adres_dowozu
JOIN subskrypcja ON adres_dowozu.subskrypcja = subskrypcja.id
WHERE subskrypcja.data_zakonczenia IS NOT NULL;

-- Usunięcie trwających subskrypcji z nieaktywnym planem
DELETE subskrypcja
FROM subskrypcja
JOIN plan ON subskrypcja.plan = plan.id
WHERE plan.status = 'nieaktywne';

-- Ustawienie odpowiedniego statusu klienta w zależności od tego czy ma subkskrypcję
UPDATE klient
SET status = 'nieaktywne'
WHERE id NOT IN (
    SELECT DISTINCT klient
    FROM subskrypcja
    WHERE data_zakonczenia IS NULL
);
