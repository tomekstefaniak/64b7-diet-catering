
-- dostawca
grant all privileges on dc.dostawa to 'dostawca'@'%';
grant select on dc.subskrypcja to 'dostawca'@'%';

grant select on dc.v_dostawa to 'dostawca'@'%';

-- kucharz
grant all privileges on dc.danie to 'kucharz'@'%';
grant all privileges on dc.skladnik to 'kucharz'@'%';
grant all privileges on dc.produkt to 'kucharz'@'%';
grant select on dc.alergia to 'kucharz'@'%';
grant select on dc.subskrypcja to 'kucharz'@'%';

grant select on dc.v_alergia to 'kucharz'@'%';

-- księgowa
grant select on dc.klient to 'ksiegowy'@'%';
grant select on dc.subskrypcja to 'ksiegowy'@'%';
grant select on dc.platnosc to 'ksiegowy'@'%';

grant select on dc.v_subksrypcje to 'ksiegowy'@'%'