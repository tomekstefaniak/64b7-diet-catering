
-- Widok na adresy związane z daną subskrypcją oraz numer telefonu do klienta
create or replace view v_dostawa as 
select 
    p.imie, 
    p.nazwisko, 
    s.id as id_subskrypcji, 
    plan.nazwa as plan,
    concat(k.imie, ' ', k.nazwisko) as klient,
    k.tel, 
    ad.miasto, 
    ad.ulica, 
    ad.numer_domu
from pracownik p 
inner join dostawa d on d.pracownik = p.id 
join subskrypcja s on s.id = d.subskrypcja 
join plan on s.plan = plan.id
join klient k on k.id = s.klient 
join adres_dowozu ad on ad.subskrypcja = s.id;

-- Widok na subskrypcje z jakimi planami które mają wpisane alergie na produkty w danym daniu
create or replace view v_alergia as
select distinct 
    d.nazwa as danie_nazwa, 
    produkt.nazwa as produkt_nazwa, 
    s.id as id_subskrypcji, 
    plan.nazwa as plan_nazwa
from danie d 
join skladnik on skladnik.danie = d.id
join produkt on produkt.id = skladnik.produkt 
join alergia on alergia.produkt = produkt.id 
join subskrypcja s on s.id = alergia.subskrypcja
join plan on s.plan = plan.id;

-- Widok na aktywne subskrypcje
CREATE VIEW v_subskrypcje AS
SELECT 
    subskrypcja.id AS subskrypcja_id,
    klient.imie AS klient_imie,
    klient.nazwisko AS klient_nazwisko,
    plan.nazwa AS plan_nazwa,
    subskrypcja.data_rozpoczecia,
    subskrypcja.data_zakonczenia
FROM subskrypcja
JOIN klient ON subskrypcja.klient = klient.id
JOIN plan ON subskrypcja.plan = plan.id
WHERE subskrypcja.data_zakonczenia is NULL;
