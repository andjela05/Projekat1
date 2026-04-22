-- Kreiranje tabele Valuta
CREATE TABLE Valuta (
    id SERIAL PRIMARY KEY,
    naziv VARCHAR(10) NOT NULL,
    vrednost_u_eur DECIMAL(15, 4)
);

-- Kreiranje tabele Korisnik
CREATE TABLE Korisnik (
    id SERIAL PRIMARY KEY,
    ime VARCHAR(50),
    prezime VARCHAR(50),
    korisnicko_ime VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    lozinka_hash TEXT NOT NULL,
    datum_rodjenja DATE,
    uloga VARCHAR(20) DEFAULT 'Korisnik', -- Korisnik, Administrator
    profilna_slika_path TEXT,
    valuta_id INT REFERENCES Valuta(id),
    datum_registracije TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    blokiran BOOLEAN DEFAULT FALSE
);

-- Kreiranje tabele Kategorija
CREATE TABLE Kategorija (
    id SERIAL PRIMARY KEY,
    naziv VARCHAR(50) NOT NULL,
    tip VARCHAR(10) CHECK (tip IN ('Prihod', 'Trosak')),
    predefinisan BOOLEAN DEFAULT FALSE,
    korisnik_id INT REFERENCES Korisnik(id) ON DELETE CASCADE
);

-- Kreiranje tabele Novcanik
CREATE TABLE Novcanik (
    id SERIAL PRIMARY KEY,
    naziv VARCHAR(50) NOT NULL,
    pocetno_stanje DECIMAL(15, 2) DEFAULT 0.00,
    trenutno_stanje DECIMAL(15, 2) DEFAULT 0.00,
    valuta_id INT REFERENCES Valuta(id),
    datum_kreiranja TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    korisnik_id INT REFERENCES Korisnik(id) ON DELETE CASCADE,
    stedni BOOLEAN DEFAULT FALSE,
    arhiviran BOOLEAN DEFAULT FALSE
);

-- Kreiranje tabele Transakcija
CREATE TABLE Transakcija (
    id SERIAL PRIMARY KEY,
    naziv VARCHAR(100),
    iznos DECIMAL(15, 2) NOT NULL,
    tip VARCHAR(10) CHECK (tip IN ('Prihod', 'Trosak')),
    kategorija_id INT REFERENCES Kategorija(id),
    datum_transakcije TIMESTAMP NOT NULL,
    ponavljajuca BOOLEAN DEFAULT FALSE,
    ucestalost VARCHAR(20), -- npr. 'mesecno', 'nedeljno'
    novcanik_id INT REFERENCES Novcanik(id) ON DELETE CASCADE,
    korisnik_id INT REFERENCES Korisnik(id) ON DELETE CASCADE
);