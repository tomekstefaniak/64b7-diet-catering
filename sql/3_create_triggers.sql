
delimiter $$

-- usunięcie dostawy odpowiadającej subskrypcji
create trigger koniec_subksrypcji_usun_dostawe
after update 
on subskrypcja
for each row
begin
    if (new.data_zakonczenia is not null) then
        delete from dostawa
        where dostawa.subskrypcja = new.id;
    end if;
end $$

-- usunięcie alergii odpowiadającej subskrypcji
create trigger koniec_subskrypcji_usun_alergie
after update 
on subskrypcja
for each row
begin
    if (new.data_zakonczenia is not null) then
        delete from alergia
        where alergia.subskrypcja = new.id;
    end if;
end $$

-- usunięcie adresu dowozu odpowiadającego subskrypcji
create trigger koniec_subksrypcji_usun_adres_dowozu
after update 
on subskrypcja
for each row
begin
    if (new.data_zakonczenia is not null) then
        delete from adres_dowozu
        where adres_dowozu.subskrypcja = new.id;
    end if;
end $$

-- aktualizacja statusu klienta po zakończeniu subskrypcji
create trigger koniec_subksrypcji_aktualizuj_status_klienta
after update
on subskrypcja
for each row
begin
    if (new.data_zakonczenia is not null and not exists (
        select 1
        from subskrypcja
        where klient = new.klient and id <> new.id
    )) then
        update klient
        set status = 'nieaktywne'
        where id = new.klient;
    end if;
end $$

-- aktualizacja statusu klienta po wstawieniu subskrypcji
create trigger wstawienie_subskrypcji_aktualizuj_status_klienta
before insert 
on subskrypcja
for each row
begin
    if not exists (
        select 1
        from subskrypcja
        where klient = new.klient
    ) then
        update klient
        set status = 'aktywne'
        where id = new.klient;
    end if;
end $$

-- sprawdzenie czy nie wstawiamy drugiej dostawy dla tej samej subskrypcji
create trigger blokuj_duplikat_dostawa
before insert
on dostawa
for each row
begin
    if exists (
        select 1 
        from dostawa
        where subskrypcja = new.subskrypcja
    ) then
        signal sqlstate '45000'
        set message_text = 'Ta subskrypcja już ma utworzoną dostawę!';
    end if;
end $$

-- sprawdzenie czy nie wstawiamy drugiego adresu dowozu dla tej samej subskrypcji
create trigger blokuj_duplikat_adres_dowozu
before insert
on adres_dowozu
for each row
begin
    if exists (
        select 1 
        from adres_dowozu
        where subskrypcja = new.subskrypcja
    ) then
        signal sqlstate '45000'
        set message_text = 'Ta subskrypcja już ma utworzony adres dowozu!';
    end if;
end $$

delimiter ;
