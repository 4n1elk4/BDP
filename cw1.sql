--1
CREATE DATABASE firma;

--2
CREATE SCHEMA ksiegowosc;

--3
CREATE TABLE pracownicy (
	id_pracownika SERIAL PRIMARY KEY,
	imie varchar(30) NOT NULL,
	nazwisko varchar(60) NOT NULL,
	adres varchar(80),
	telefon int
);

CREATE TABLE godziny (
	id_godziny SERIAL PRIMARY KEY,
	data date NOT NULL,
	liczba_godzin int,
	id_pracownika int,
	FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika)
);

CREATE TABLE pensja (
	id_pensji SERIAL PRIMARY KEY,
	stanowisko varchar(50),
	kwota int
);

CREATE TABLE premia (
	id_premii SERIAL PRIMARY KEY,
	rodzaj varchar(50),
	kwota int
);

CREATE TABLE wynagrodzenie (
	id_wynagrodzenia SERIAL PRIMARY KEY,
	data date NOT NULL,
	id_pracownika int,
	id_godziny int,
	id_pensji int,
	id_premii int,
	FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika),
	FOREIGN KEY (id_godziny) REFERENCES godziny(id_godziny),
	FOREIGN KEY (id_pensji) REFERENCES pensja(id_pensji),
	FOREIGN KEY (id_premii) REFERENCES premia(id_premii)
);

--4
INSERT INTO pracownicy (imie, nazwisko, adres, telefon)
    VALUES ('Jan', 'Brzechwa', 'ul. Stawowa 51, Krakow', 859384102),
	('Weronika', 'Giworak', 'ul. Nadwislanska 104, Opole', 948302341),
	('Andrzej', 'Witek', 'ul. Kwiatowa 22, Krakow', 782943203),
	('Wiktor', 'Nowak', 'ul. Rzeczna 10, Wroclaw', 673829102),
	('Piotr', 'Kowalski', 'ul. Zielona 5, Gdansk', 558392111),
	('Janina', 'Pojda', 'ul. Polna 2, Lublin', 812248905),
	('Bartlomiej', 'Mazur', 'ul. Długa 67, Krakow', 912348763),
	('Grzegorz', 'Kiszka', 'ul. Ogrodowa 11, Katowice', 537920123),
	('Izabela', 'Nowicka', 'ul. Wrzosowa 8, Krakow', 519283746),
	('Patrycja', 'Kinpel', 'ul. Krolewska 23, Sopot', 832901974);


INSERT INTO godziny (data, liczba_godzin, id_pracownika)
    VALUES ('2024-10-14', 6, 2),
    ('2024-10-14', 8, 3),
	('2024-10-14', 9, 4),
	('2024-10-14', 7, 5),
	('2024-10-14', 4, 6),
	('2024-10-14', 8, 7),
	('2024-10-14', 6, 8),
	('2024-10-14', 9, 9),
	('2024-10-14', 5, 10),('2024-10-01', 10, 1),
	('2024-10-02', 10, 1),
	('2024-10-03', 8, 1),
	('2024-10-04', 8, 1),
	('2024-10-05', 9, 1),
	('2024-10-08', 8, 1),
	('2024-10-09', 9, 1),
	('2024-10-10', 8, 1),
	('2024-10-11', 8, 1),
	('2024-10-12', 8, 1),
	('2024-10-15', 8, 1),
	('2024-10-16', 10, 1),
	('2024-10-17', 7, 1),
	('2024-10-18', 9, 1),
	('2024-10-19', 6, 1),
	('2024-10-22', 8, 1),
	('2024-10-23', 8, 1),
	('2024-10-24', 8, 1),
	('2024-10-25', 6, 1),
	('2024-10-26', 8, 1),
	('2024-10-28', 8, 1),
	('2024-10-29', 8, 1),
	('2024-10-30', 8, 1);

INSERT INTO pensja (stanowisko, kwota)
    VALUES ('Manager', 5000),
    ('Księgowy', 4000),
    ('Analityk', 4600),
    ('Specjalista HR', 3800),
    ('Programista', 6000),
    ('Pracownik Usług Czystościowych', 900),
    ('Kierownik Projektu', 5500),
    ('Recepcjonista', 3000),
    ('Technik', 3500),
    ('Grafik', 4200);
	
INSERT INTO premia (rodzaj, kwota)
    VALUES ('Okazjonalna', 500),
    ('Roczna', 1000),
    ('Motywacyjna', 300),
    ('Świąteczna', 800),
    ('Wynikowa', 600),
    ('Indywidualna', 200),
    ('Prowizyjna', 400),
    ('Za nadgodziny', 700),
    ('Frekwencyjna', 350),
    ('Jubileuszowa', 1500);

INSERT INTO wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii)
    VALUES ('2024-10-14', 1, 2, 8, 8),
    ('2024-10-14', 2, 3, 2, NULL),
    ('2024-10-14', 3, 4, 5, 8),
    ('2024-10-14', 4, 5, 3, 10),
    ('2024-10-14', 5, 6, 1, 3),
    ('2024-10-14', 6, 7, 3, NULL),
    ('2024-10-14', 7, 8, 6, NULL),
    ('2024-10-14', 8, 9, 8, 2),
    ('2024-10-14', 9, 10, 1, 7),
    ('2024-10-14', 10, 1, 2, NULL);

--5
--a
SELECT id_pracownika, nazwisko
FROM pracownicy

--b
SELECT w.id_pracownika
FROM wynagrodzenie as w
JOIN pensja as p
ON w.id_pensji = p.id_pensji
WHERE p.kwota > 1000

--c
SELECT w.id_pracownika
FROM wynagrodzenie as w
JOIN pensja as pe
ON w.id_pensji = pe.id_pensji
LEFT JOIN premia as pa 
ON w.id_premii = pa.id_premii
WHERE pa.id_premii IS NULL
AND pe.kwota > 2000

--d
SELECT *
FROM pracownicy
WHERE imie LIKE 'J%'

--e
SELECT * 
FROM pracownicy 
WHERE nazwisko ILIKE '%n%'
AND imie LIKE '%a'

--f
SELECT p.imie,
	p.nazwisko,
	SUM(g.liczba_godzin)-160 as nadgodziny
FROM pracownicy as p
LEFT JOIN godziny as g
ON p.id_pracownika = g.id_pracownika
GROUP BY p.id_pracownika, p.imie, p.nazwisko

--g
SELECT p.imie, 
	p.nazwisko,
	pe.kwota
FROM wynagrodzenie as w
JOIN pracownicy as p
ON w.id_pracownika = p.id_pracownika
JOIN pensja as pe
ON w.id_pensji = pe.id_pensji
WHERE pe.kwota >= 1500
AND pe.kwota <= 3000

--h 
SELECT pr.imie,
	pr.nazwisko,
	SUM(g.liczba_godzin)-160 as nadgodziny
FROM wynagrodzenie as w
JOIN pracownicy as pr
ON pr.id_pracownika = w.id_pracownika
LEFT JOIN godziny as g
ON pr.id_pracownika = g.id_pracownika
LEFT JOIN premia as pa 
ON w.id_premii = pa.id_premii
WHERE pa.id_premii IS NULL
GROUP BY pr.id_pracownika, pr.imie, pr.nazwisko
HAVING SUM(g.liczba_godzin)-160 > 0


--i
SELECT imie, 
	nazwisko,
	pe.kwota
FROM wynagrodzenie as w
JOIN pracownicy as p
ON w.id_pracownika = p.id_pracownika
JOIN pensja as pe
ON w.id_pensji = pe.id_pensji
ORDER BY pe.kwota

--j
SELECT imie, 
	nazwisko,
	pe.kwota as zarobek,
	pr.kwota as premia
FROM wynagrodzenie as w
JOIN pracownicy as p
ON w.id_pracownika = p.id_pracownika
JOIN pensja as pe
ON w.id_pensji = pe.id_pensji
LEFT JOIN premia as pr
ON w.id_premii = pr.id_premii
ORDER BY pe.kwota, pr.kwota

--k
SELECT p.imie,
	p.nazwisko,
	pe.stanowisko
FROM wynagrodzenie as w
JOIN pracownicy as p
ON w.id_pracownika = p.id_pracownika
JOIN pensja as pe
ON w.id_pensji = pe.id_pensji
GROUP BY pe.stanowisko, p.imie, p.nazwisko

--l
SELECT AVG(kwota),
	MIN(kwota),
	MAX(kwota)
FROM pensja as pe
LEFT JOIN wynagrodzenie as w
ON w.id_pensji = pe.id_pensji
WHERE pe.stanowisko = 'Analityk'

--m
SELECT SUM(pe.kwota) + SUM(pa.kwota) as suma_wynagrodzen
FROM pensja as pe
LEFT JOIN wynagrodzenie as w
ON w.id_pensji = pe.id_pensji
LEFT JOIN premia as pa
ON w.id_premii = pa.id_premii

--n
SELECT SUM(pe.kwota) + SUM(COALESCE(pa.kwota, 0)) as suma_wynagrodzen,
	pe.stanowisko
FROM pensja as pe
LEFT JOIN wynagrodzenie as w
ON w.id_pensji = pe.id_pensji
LEFT JOIN premia as pa
ON w.id_premii = pa.id_premii
GROUP BY stanowisko

--o
SELECT COUNT(pa.kwota) as suma_premii,
	pe.stanowisko
FROM pensja as pe
LEFT JOIN wynagrodzenie as w
ON w.id_pensji = pe.id_pensji
LEFT JOIN premia as pa
ON w.id_premii = pa.id_premii
GROUP BY stanowisko

--p
DELETE FROM pracownicy
USING wynagrodzenie AS w, pensja AS pe
WHERE pracownicy.id_pracownika = w.id_pracownika
AND w.id_pensji = pe.id_pensji
AND pe.kwota < 1200;
