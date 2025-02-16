-- baza danych
drop database dc;
create database dc;
use dc;

-- pracownik
create table pracownik (
  id int auto_increment primary key,
  imie varchar(50),
  nazwisko varchar(50),
  mail varchar(100),
  tel char(15),
  adres varchar(255),
  posada varchar(30), -- admin, dostawca, kucharz, ksiegowy 
  pesel char(11),
  pensja int,
  rachunek varchar(26)
);

-- klient
create table klient (
  id int auto_increment primary key,
  imie varchar(50),
  nazwisko varchar(50),
  mail varchar(100),
  tel varchar(15),
  status varchar(20) -- aktywne, nieaktywne
);

-- plan
create table plan (
  id int auto_increment primary key,
  nazwa varchar(100),
  liczba_dan int,
  podaz_kaloryczna int,
  cena int,
  status varchar(20) -- aktywne, nieaktywne
);

-- subskrypcja
create table subskrypcja (
  id int auto_increment primary key,
  klient int not null,
  plan int not null,
  data_rozpoczecia date not null,
  data_zakonczenia date,
  foreign key (klient) references klient (id),
  foreign key (plan) references plan (id)
);

-- adres_dowozu
create table adres_dowozu (
  subskrypcja int primary key,
  ulica varchar(100),
  numer_domu varchar(15),
  miasto varchar(100),
  kod_pocztowy varchar(15),
  kraj varchar(30),
  foreign key (subskrypcja) references subskrypcja (id) on delete cascade
);

-- produkt
create table produkt (
  id int auto_increment primary key,
  nazwa varchar(100)
);

-- alergia
create table alergia (
  subskrypcja int not null,
  produkt int not null,
  primary key (subskrypcja, produkt),
  foreign key (subskrypcja) references subskrypcja (id) on delete cascade,
  foreign key (produkt) references produkt (id) on delete cascade
);

-- danie
create table danie (
  id int auto_increment primary key,
  nazwa varchar(100)
);

-- skladnik
create table skladnik (
  danie int not null,
  produkt int not null,
  primary key (danie, produkt),
  foreign key (danie) references danie (id) on delete cascade,
  foreign key (produkt) references produkt (id) on delete cascade
);

-- platnosc
create table platnosc (
  subskrypcja int not null,
  data_zaplaty date not null,
  metoda varchar(20),
  primary key (subskrypcja, data_zaplaty),
  foreign key (subskrypcja) references subskrypcja (id) on delete cascade
);

-- dostawa
create table dostawa (
  subskrypcja int not null primary key,
  pracownik int not null,
  foreign key (pracownik) references pracownik (id) on delete cascade,
  foreign key (subskrypcja) references subskrypcja (id) on delete cascade
);
