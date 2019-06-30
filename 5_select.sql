--   AUTHOR:    MICHAL ZAWILSKI

-- VIEW 1: WIDOK NA OTWARTE ZGLOSZENIA POSORTOWANE OD PRIORYTETU I DATY --

CREATE OR REPLACE VIEW OTWARTE_ZGLOSZENIA AS
SELECT PRACOWNICY.NAZWISKO, TYP_ZGLOSZENIA.TYP, TYP_ZGLOSZENIA.PRIORYTET, OPIS 
FROM TICKETS
INNER JOIN PRACOWNICY ON TICKETS.PRACOWNIK=PRACOWNICY.ID
INNER JOIN TYP_ZGLOSZENIA ON TICKETS.TYP_ZGLOSZENIA=TYP_ZGLOSZENIA.ID
WHERE ZAKONCZONE = 'F'
ORDER BY TYP_ZGLOSZENIA.PRIORYTET, TICKETS.DATA_ZGLOSZENIA;

--SELECT * FROM OTWARTE_ZGLOSZENIA;

-- VIEW 2: WIDOK NA SUME WPLAT I SUME NALEZNOSCI --
 
CREATE OR REPLACE VIEW ZESTAWIENIE_NALEZNOSCI_WPLATY AS
SELECT 
    Q1.KLIENT_ID,
    Q1.KLIENT,
    Q1.NALEZNOSC,
    Q2.WPLATY
FROM 
    (SELECT 
    KLIENT_ID AS KLIENT_ID,
    KLIENT.NAZWISKO || ' ' || KLIENT.IMIE AS KLIENT,
    SUM(FAKTURY.NALEZNOSC) AS NALEZNOSC
    FROM FAKTURY
    INNER JOIN KLIENT ON KLIENT.ID=FAKTURY.KLIENT_ID 
    GROUP BY KLIENT_ID, KLIENT.NAZWISKO || ' ' || KLIENT.IMIE) Q1
JOIN
    (SELECT
    FAKTURY_KLIENT_ID AS KLIENT_ID, 
    KLIENT.NAZWISKO || ' ' || KLIENT.IMIE AS KLIENT,
    SUM(KWOTA_WPLACONA) AS WPLATY
    FROM PLATNOSCI
    INNER JOIN KLIENT ON KLIENT.ID = PLATNOSCI.FAKTURY_KLIENT_ID
    GROUP BY FAKTURY_KLIENT_ID, KLIENT.NAZWISKO || ' ' || KLIENT.IMIE) Q2
ON Q1.KLIENT_ID=Q2.KLIENT_ID
ORDER BY KLIENT_ID ASC;
SELECT * FROM ZESTAWIENIE_NALEZNOSCI_WPLATY;

-- VIEW 3: WIDOK NA ILOSC OTWARTYCH ZLENE PER PRACOWNIK -- 

CREATE OR REPLACE VIEW ILOSC_ZLECEN  AS
SELECT TICKETS.PRACOWNIK AS ID_PRACOWNIKA, PRACOWNICY.IMIE || ' ' || PRACOWNICY.NAZWISKO AS PRACOWNIK, COUNT(ZAKONCZONE) AS LICZBA FROM TICKETS
INNER JOIN PRACOWNICY ON PRACOWNICY.ID = TICKETS.PRACOWNIK
WHERE ZAKONCZONE = 'F'
GROUP BY TICKETS.PRACOWNIK, PRACOWNICY.IMIE || ' ' || PRACOWNICY.NAZWISKO
ORDER BY COUNT(ZAKONCZONE);

SELECT * FROM ILOSC_ZLECEN;
