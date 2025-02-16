delimiter $$

-- aktywne subskrypcje dla klienta
create procedure klient_aktywne_subskrypcje(in klientId int)
begin
    select 
        s.id as subskrypcja_id,
        p.nazwa as plan,
        date_format(s.data_rozpoczecia, '%Y-%m-%d') as data_rozpoczecia,
        date_format(s.data_zakonczenia, '%Y-%m-%d') as data_zakonczenia
    from subskrypcja s
    join plan p on s.plan = p.id
    where s.klient = klientId
      and (s.data_zakonczenia is null or s.data_zakonczenia >= curdate());
end$$

-- dowozy dla danego pracownika
create procedure dowozy_dla_pracownika(in pracownikId int)
begin
    select 
        p.imie, 
        p.nazwisko, 
        s.id as id_subskrypcji, 
        plan.nazwa as plan, 
        k.tel, 
        ad.miasto, 
        ad.ulica, 
        ad.numer_domu
    from pracownik p 
    join dostawa d on d.pracownik = p.id 
    join subskrypcja s on s.id = d.subskrypcja 
    join plan on s.plan = plan.id 
    join klient k on k.id = s.klient 
    join adres_dowozu ad on ad.subskrypcja = s.id
    where p.id = pracownikId;
end$$

-- wyświetla subskrypcje i alergie dla danego dania
create procedure alergie_subskrypcji_dla_dania(in danieId int)
begin
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
    join plan on s.plan = plan.id
    where d.id = danieId;
end$$

delimiter ;
