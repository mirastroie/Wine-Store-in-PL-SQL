
--1. Crearea tabelelor
create table categories(
   categoryid number(1) primary key,
   categoryname varchar2(15)
);

create table wines(
   wineid number(5) primary key,
   winename varchar2(40) not null unique,
   description varchar2(1000) not null,
   tastingnotes varchar2(300),
   abv number(4,2) check (abv between 0 and 21),
   year number(4) check (year between 2010 and 2020),
   price number(6,2) not null check (price > 0),
   bottlesize number(3,1),
   stock number(4) check (stock > 0),
   categoryid number(1) references categories(categoryid) on delete cascade
);


create table countries(
   countryid char(2) primary key,
   countryname varchar2(40)
);
create table regions(
   regionid number(2) primary key,
   regionname varchar2(40),
   countryid char(2) references countries(countryid)
);
create table producers(
   producerid number(4) primary key,
   producername varchar2(20) not null,
   description varchar2(300),
   regionid number(2) references regions(regionid)
);

alter table wines
add  producerid number(4) references producers(producerid);

create table members(
  memberid number(4) primary key,
  email varchar2(30) not null,
  password varchar2(20) not null,
  firstname varchar2(15),
  lastname varchar2(20),
  username varchar2(20) not null,
  phone char(10),
  bithdate date not null
);

alter table members
rename column bithdate to birthdate;

create table addresses(
  addressid number(4) primary key,
  streetaddress varchar2(120) not null,
  postalcode varchar2(7),
  regionid number(2) references regions(regionid),
  city varchar2(25) not null,
  memberid number(4) references members(memberid)
);

create table creditcards(
   cardid number(5) primary key,
   cardtype varchar2(20),
   pan char(16) not null,
   expirationdate date,
   cardholder varchar2(50) not null,
   memberid number(4) references members(memberid),
   constraint check_cardtype
   check (upper(cardtype) in ('AMERICAN EXPRESS','MASTERCARD','VISA','DISCOVER'))
);
create table orders(
    orderid number(4) primary key,
    orderdate date,
    shippingdate date,
    billingaddress number(4) references addresses(addressid),
    deliveryaddress number(4) references addresses(addressid),
    totalprice number(6,2) not null,
    totaldiscount number(6,2) not null,
    cardid number(5) references creditcards(cardid),
    memberid number(4) references members(memberid)
);
create table order_wine
(
   orderid number(4) references orders(orderid),
   wineid number(4) references wines(wineid),
   quantity number(2) not null,
   orderprice number(6,2),
   primary key(orderid,wineid)
);

create table plans(
   planid number(4) primary key,
   planname varchar2(20) not null,
   description varchar2(400),
   planprice number(6,2),
   dayofmonth char(2),
   nowines number
);

create table subscription
(
   subscriptionid number(4) primary key,
   startdate date,
   enddate date,
   billingaddress number(4) references addresses(addressid),
   deliveryaddress number(4) references addresses(addressid),
   cardid number(5) references creditcards(cardid),
   memberid number(4) references members(memberid),
   planid number(4) references plans(planid)
);
create table plan_wine(
   planwineid number(4) primary key,
   planid number(4) not null references plans(planid),
   wineid number(4) not null references wines(wineid),
   period date not null,
   constraint uni_plan_wine unique(planid,wineid,period)
);

create table discounts(
   discountid number(4) primary key,
   discountname varchar2(20),
   startdate date,
   enddate date,
   percentage number(3,1) 
);
create table wine_discount(
   wineid number(4) references wines(wineid),
   discountid number(4) references discounts(discountid),
   primary key(wineid,discountid)
);

--2. Populam cu date

--inseram in categories

insert into categories 
values (1,'Red');
insert into categories
values (2,'Rose');
insert into categories
values(3,'White');
--inseram in countries
insert into countries
values ('US','United States of America');
insert into countries
values ('AU','Australia');
insert into countries
values ('FR','France');
insert into countries
values ('CH','Switzerland');
insert into countries
values('AR','Argentina');
insert into countries
values ('NZ','New Zealand');

--inseram in regions
insert into regions 
values(1,'California','US');
insert into regions
values(2,'Central Otago','NZ');
insert into regions
values(3,'Oregon','US');
insert into regions
values(4,'Victoria','AU');
insert into regions
values(5,'Western Australia','AU');
insert into regions
values(6,'Alsace','FR');
insert into regions
values(7,'Bordeaux','FR');
insert into regions
values(8,'Burgundy','FR');

--inseram in producers
insert into producers
values(1,'Leeuwin Estate','Family owned, Leeuwin Estate, one of the five founding wineries of the now famous Margaret River district of Western Australia, is under the direction of two generations who work with a team of highly skilled winemakers to consistently produce wines ranking alongside the world’s finest.',5);
insert into producers
values(2,'Yarra Yering','Yarra Yering is one of the oldest and most beautiful vineyards in the Yarra
Valley consisting of 28 hectares of vines located at the foot of the Warramate Hills.',4);
insert into producers
values(3,'Chateau Montelena','Chateau Montelena is a Napa Valley winery most famous for winning the
white wine section of the historic "Judgment of Paris" wine competition.',1);
insert into producers
values(4,'Domaine Leflaive','Domaine Leflaive is a winery in Puligny-Montrachet, Côte de Beaune, Burgundy. 
The domaine is very highly regarded for its white wines, and its vineyard holdings include 5.1 hectares of Grand Cru vineyards.',8);
insert into producers
values(5,'Domaine Guy Amiot',null,8);
insert into producers
values(6,'Ridge Vineyards',null,1);
insert into producers
values(7,'Château Palmer','Château Palmer is a winery in Bordeaux, France. The wine produced here was classified as one
of fourteen Troisièmes Crus in the historic Bordeaux Wine Official Classification of 1855.',7);

--inseram in wines
--create sequence wines_seq
--start with 1
--increment by 1;

insert into wines
values(1,'Bienvenue Bâtard Montrachet','Bienvenues Bâtard Montrachet borders the Grand Cru 
vineyard Bâtard-Montrachet in the west and south and the Puligny-Montrachet Premier Cru 
Les Pucelles in the north.','Golden in colour, the bouquet is rich with a hint of butterscotch.
The palate is delicious, very rich and aristocratic, complex, multi dimensional
with layers of characterful fruit.',14,2010,900,75,100,3,4);

insert into wines
values(2,'Angels Flight','Full of juicy ripe strawberry and a hint of cream, perfect for those who prefer their wine with a touch of sweetness.',
'Bright aromas of strawberry and watermelon. The full, ripe fruit flavours are well balanced with a refreshing mouthfeel and a slight crisp, lingering finish.',
10,2018,20.4,75,65,2,2);

insert into wines
values(3,'Boulevard Blush','Plenty of strawberry fruit flavours in this classic blush style, with that signature sweetness.',
'Perfect for those who enjoy a sweeter rose, this has ripe, juicy flavours of watermelon and strawberry which lead to a long sweet finish.',
10,2014,19.99,75,34,2,2);

insert into wines
values(4,'Smoking Loon Old Vine','The grapes used to make this wine were sourced from multiple locations, most notably Lodi and Paso Robles.',
'Juicy aromas of plum, raspberry and mocha.',14,2017,12.99,75,21,1,2);



insert into wines
values(5,'Krondorf Shiraz','A robust Shiraz wine from the Barossa that is ready to enjoy now but will also develop for 4 - 5 years. Flavours of blackberry and spicy blackcurrant.',
'A nose of dark berries and spice.',14.5,2016,78.99,75,89,1,1);

insert into wines
values(6,'Cabernet Sauvignon Shiraz','A big ripe wine with aromas of cedar and spicy cassis.','The terroir delivers complexity involving the aroma and flavour of dusty earth and Eucalypt smoke. The aroma is complex and powerful, dominated by ripe blackberry and plum fruit.',
16,2013,44.99,65,55,1,2);

insert into wines
values(7,'Art Series Riesling','Energy and vitality is at the forefront on the palate, finger limes is the thread with subtleties of lemon sherbet.',
'A fragrant and delicate nose that features cut lime, lemon and apple, combining with Kaffir leaf, Thai basil and lemongrass',
13.5,2019,19.99,75,20,3,1);

insert into wines
values(8,'Puligny Montrachet','This vintage sits comfortably in the top ranks of vintages at this domaine, which has some of the greatest terroir in the world and whose results are always inspirational and frequently spectacular.',
'A wine of real finesse and elegance with notes of fine aniseed, clove and pears.',
13,2018,15.50,75,67,3,4);

insert into wines
values(9,'Chassagne-Montrachet','2018 is a "Grand" vintage: solar, powerful, generous... we wish we had more like this one in Burgundy!','Particularly high yields and alcoholic degrees (up to 15%/alc in some plots).',
15,2013,17,75,34,1,5);

-- inseram in plans
desc plans;
insert into plans
values(1,'The Explore','Built around a changing theme — such as a classic wine region, a specific grape variety, or the best wines of the season — 
this four-bottle selection offers a unique introduction to the world of wine, whether you want to grow your knowledge or just drink the good stuff.',
99,'04',4);
insert into plans
values(2,'The Blind','If you’re looking to refine your palate, expand your skills, or enjoy a fun way to drink great wine with friends, this club delivers
six bottles that are wrapped in black tissue paper and numbered for an authentic “blind tasting” experience.',
199,'12',6);
insert into plans
values(3,'The Grand Tour','We created The Grand Tour to bring the great work of the winemakers we love straight to your door. As a TGT member ($95/month + shipping), your monthly delivery will include four bottles
of hand-selected wine from the featured region or theme of that month.',95,'18',3);
select * from plans;
desc members;

insert into members
values(1,'tate@gmail.com','Tate@1234','Tate','Robinson','tate23','2025550104','2-JAN-1996');

insert into members
values(2,'america@gmail.com','America!23','America','Rogers','arogers','2025550129','14-JUN-1986');

insert into members
values(3,'rachel@gmail.com','!rach#2','Rachel','Williams','rachelwill','5807901036','26-SEP-1999');

insert into members
values(4,'dominic@yahoo.com','DomInIC3','Dominic','Clinton','dclinton','8483910069','10-NOV-1958');

insert into members
values(5,'levi@bitdefender.com','LewisC','Levi','Carter','cartlevi','5406367427','31-DEC-1989');

insert into members
values(6,'emily67@gmail.com','123Emily321','Emily','Gilmore','emilygilmore','5189269142','14-FEB-1955');

insert into members
values(7,'milescooper@gmail.com','Mileage@123','Miles','Cooper','milescooper','6312219320','22-MAY-1992');

insert into members
values(8,'curtisatt@gmail.com','Curtis22','Curtis','Attwood','curtisattwood','9106327426','13-SEP-1888');

insert into members
values(9,'tess28@gmail.com','tessalovespuppies','Theresa','Gearhart','tessagearhart','8435055048','28-JAN-2000');

select * from members;
desc addresses;
select * from regions;
insert into  addresses
values(1,'505 W Lambert Rd','0211000',1,'Brea',1);
insert into addresses
values(2,'487 E Middlefield Rd','9404300',1,'Mountain View',2);

insert into addresses
values(3,'2911 Elm Ave','90266',1,'Manhattan Beach',3);

insert into addresses
values(4,'29 Mildura Street','7216',4,'The Gardens',4);
insert into addresses
values(5,'86 Hebbard Street','3183',5,'St Kilda East',5);
insert into addresses
values(6,'118  rue Grande Fusterie','91800',7, 'BRUNOY',6);
insert into addresses
values(7,'30  rue des Soeurs','06160',8,'JUAN-LES-PINS',7);

insert into addresses
values(8,'31 Marshall Ave.','95123', 1, 'San Jose', 1);

insert into addresses
values(9,'97  rue des Coudriers','03000',6,'Moulins',9);

insert into addresses
values(10,'899  Armory Road','90001',1,'Los Angeles',2);

--subscriptions

desc subscription;
insert into subscription
values(1,'3-NOV-2018','3-NOV-2021',1,1,1,1,1);

insert into subscription
values(2,'5-DEC-2019','6-DEC-2022',2,2,2,2,1);

insert into subscription
values(3,'28-AUG-2018','18-FEB-2021',3,3,3,3,2);

insert into subscription
values(4,'6-SEP-2019','6-SEP-2021',4,4,4,4,2);

insert into subscription
values(5,'18-NOV-2020','18-NOV-2021',5,5,5,5,3);

insert into subscription
values(6,'3-MAR-2020','3-MAR-2021',6,6,6,6,3);

insert into subscription
values(7,'16-MAY-2020','16-MAY-2021',7,7,7,7,3);
select * from subscription;


select * from members;
desc creditcards;
insert into creditcards
values(1,'Visa','4638413934278091','1-NOV-2023','Tate Robinson',1);

insert into creditcards
values(2,'Visa','4776733275746121','1-DEC-2023','America Rogers',2);

insert into creditcards
values(3,'Visa','4829266122034000','1-NOV-2023','Rachel Williams',3);

insert into creditcards
values(4,'American Express','3449849272194930','1-MAR-2028','Dominic Edward Clinton',4);

insert into creditcards
values(5,'American Express','3787543030379520','1-JUN-2028','Dona Carter',5);

insert into creditcards
values(6,'Mastercard','5142081410702854','1-FEB-2024','Emily Gilmore',6);

insert into creditcards
values(7,'Discover','6011321619825189','1-JUN-2021','Miles Cooper',7);

insert into creditcards
values(8, 'American Express','3775452613251110','1-FEB-2024','Angelina Cooper',7);

insert into orders
values(1,'3-NOV-2020','4-NOV-2020',1,1,65.39,0,1,1);
insert into orders
values(2,'5-DEC-2020','10-DEC-2020',1,1,720,180,1,1);

insert into orders
values(3,'14-JAN-2019','16-JAN-2016',2,2, 48.48,0,2,2);

insert into orders
values(4,'6-SEP-2020','6-SEP-2020',3,3,44.99,0,3,3);

insert into orders
values(5,'18-AUG-2020','23-AUG-2020',4,4,78.99,0,4,4);

insert into orders
values(6,'25-JUN-2020','1-AUG-2020',5,5,98.98,0,5,5);

insert into orders
values(7,'17-APR-2020','21-APR-2020',6,6,19.99,0,6,6);

insert into orders
values(8,'10-FEB-2020','12-FEB-2020',7,7,85.65,15.12,7,7);

insert into orders
values(9,'4-JAN-21','4-JAN-21',2,2,60.79,0,2,2);

insert into orders
values(10,'4-JAN-2021','5-JAN-2021',2,2,80.1,2.79,2,2);

insert into orders values(12,'5-JAN-2021','6-JAN-2021',3,3,333.88,17.57,3,3);

insert into orders 
values(13,'9-JAN-2021','10-JAN-2021',8,8,183.8,9.67,1,1);

insert into orders
values(14,'7-JAN-2021','7-JAN-2021',10,10,33.72,1.77,2,2);

insert into orders
values(15,'7-JAN-2021','7-JAN-2021',10,10,46.5,0,2,2);


insert into orders
values(16,'7-JAN-2021','7-JAN-2021',10,10,58.14,3.06,2,2);

insert into orders
values(17,'5-JAN-2021','6-JAN-2021',10,10,44.99,0,2,2);


insert into orders
values(18,'6-JAN-2021','6-JAN-2021',6,6,17 ,0,6,6);

insert into order_wine
values(18,9,1,17);

insert into order_wine
values(17,6,1,44.99);

insert into order_wine
values(16,2,3,19.38);


insert into order_wine
values(15,8,3,15.5);


insert into order_wine
values(14,8,1,14.73);
insert into order_wine
values(14,7,1,18.99);



insert into order_wine
values(13,7,1,18.99);
insert into order_wine
values(13,5,2,75.04);
insert into order_wine
values(13,8,1,14.73);


insert into order_wine
values(12,7,1,18.99);
insert into order_wine
values(12,5,4,75.04);
insert into order_wine
values(12,8,1,14.73);



insert into order_wine
values(10,7,1,20.99);
insert into order_wine 
values(10,8,1,16.28);
insert into order_wine
values(10,2,2,21.42);

insert into order_wine
values(9,2,2,20.4);
insert into order_wine
values(9,7,1,19.99);

desc order_wine;
--pentru orderid = 1
insert into order_wine
values(1,2,1,20.4);
insert into order_wine
values(1,6,1,44.99);
--pentru orderid = 2
insert into order_wine
values(2,1,1,720);
--pentru orderid = 3
insert into order_wine
values(3,4,1,12.99);
insert into order_wine
values(3,7,1,19.99);
insert into order_wine
values(3,8,1, 15.5);
--pentru orderid = 4
insert into order_wine
values(4,6,1,44.99);
--pentru orderid = 5
insert into order_wine
values(5,5,1,78.99);
--pentru orderid = 6
insert into order_wine
values(6,5,1,78.99);
insert into order_wine
values(6,3,1,19.99);
--pentru orderid = 7
insert into order_wine
values(7,3,1,19.99);
--pentru orderid = 8
insert into order_wine
values(8,7,3,16.99);
insert into order_wine
values(8,2,2,17.34);


insert into discounts
values(1,'Valentine Wine','7-FEB-2020','15-FEB-2020',15);
insert into discounts
values(2,'Christmas Time','1-DEC-2020','23-DEC-2020',20);
insert into discounts
values(3,'2020 Summer Sale','1-JUN-2020','7-JUN-2020',7);

desc wine_discount;
insert into wine_discount
values(1,2);
insert into wine_discount
values(2,1);
insert into wine_discount
values(7,2);
insert into wine_discount
values(1,3);
insert into wine_discount
values(2,3);
insert into wine_discount
values(6,3);
insert into wine_discount
values(6,2);
insert into wine_discount
values(1,1);
insert into wine_discount
values(7,1);
insert into wine_discount
values(3,2);
insert into wine_discount
values(4,1);


desc plan_wine;
insert into plan_wine
values(1,1,3,'1-DEC-2020');
insert into plan_wine
values(2,1,4,'1-DEC-2020');
insert into plan_wine
values(3,1,8,'1-DEC-2020');

insert into plan_wine
values(4,2,2,'1-DEC-2020');
insert into plan_wine
values(5,2,3,'1-DEC-2020');
insert into plan_wine
values(6,2,4,'1-DEC-2020');
insert into plan_wine
values(7,2,5,'1-DEC-2020');
insert into plan_wine
values(8,2,6,'1-DEC-2020');
insert into plan_wine
values(9,2,7,'1-DEC-2020');
insert into plan_wine
values(10,3,3,'1-DEC-2020');
insert into plan_wine
values(11,3,8,'1-DEC-2020');
insert into plan_wine
values(12,3,7,'1-DEC-2020');
insert into plan_wine
values(13,1,7,'1-DEC-2020');

commit;

--Exercitiul 6




create or replace procedure changeprices(producator IN producers.producerid%type) is
--pret_minim = pretul la care ne raportam
pret_minim pls_integer;
type t_wines is table of wines.wineid%type;
type r_wine is record (nume wines.winename%type, pret wines.price%type);
type t_price is table of r_wine;
wine_taken t_wines := t_wines();
updated_price t_price;
nr pls_integer;
no_producer exception;
pragma exception_init(no_producer,-20030);
begin
--aflam pretul in raport cu care o sa schimbam preturile vinurilor
select count(*) into nr from producers where producerid = producator;
if nr = 0 then 
   raise_application_error(-20030,'Nu exista un producator cu acest id!');
end if;
select max(min(price))
into pret_minim
from wines
group by producerid;

----colectam toate vinurile cu proprietatea ceruta
select wineid
bulk collect into wine_taken
from wines
where producerid = producator
and price <= pret_minim;

if wine_taken.count = 0 then
    dbms_output.put_line('Niciun vin al producatorului dat nu respecta proprietatea ceruta!');
else
    ---- actualizam preturile tuturor vinurilor luate in considerare,
    ---- retinem, de asemenea, preturile noi si denumirile vinurilor modificate
    forall ind in 1..wine_taken.count 
          update wines
          set price = price*10/100 + pret_minim
          where wineid = wine_taken(ind)
          returning winename,price bulk collect into updated_price;
    
    dbms_output.put_line('Numele si preturile noi sunt :');
    for i in 1..(updated_price.count) loop
       dbms_output.put_line(updated_price(i).nume || ' ' || updated_price(i).pret);
    end loop;
end if;
exception
when no_producer then
   dbms_output.put_line('Nu exista un producator cu id-ul dat!');
when others then
   dbms_output.put_line('Eroare!');
end changeprices;
/

--select wineid, winename, price, producerid from wines order by 4;
begin
    changeprices(2);
end;
/


rollback;

-- Exercitiul 7
create or replace procedure castiguri is
cursor castig_regiune
is select regionname, 
          cursor(select producername, cursor(
                    select max(winename), sum(orderprice*quantity) as castig_vin
                    from wines w join order_wine ow on ow.wineid = w.wineid
                    where w.producerid = p.producerid 
                    group by w.wineid
                    order by castig_vin desc)
          from producers p
          where p.regionid = r.regionid)
    from regions r;
v_cursor1 sys_refcursor;
v_cursor2 sys_refcursor;
nume_regiune regions.regionname%type;
nume_producator producers.producername%type;
nume_vin wines.winename%type;
castig_vin float := 0;
castig_producator float := 0;
castig_re float := 0;
begin
open castig_regiune;
loop
   fetch castig_regiune into nume_regiune,v_cursor1;
   exit when castig_regiune%notfound;
   castig_re := 0;
   dbms_output.put_line(' x  Pentru regiunea: ' || nume_regiune);
   --cursor secundar: producator
   loop
      fetch v_cursor1 into nume_producator, v_cursor2;
      exit when v_cursor1%notfound;
      castig_producator := 0;
      dbms_output.put_line('       xx Pentru producatorul : ' || nume_producator);
      -- al treilea cursor: vinuri
      loop
        fetch v_cursor2 into nume_vin, castig_vin;
        exit when v_cursor2%notfound;
            dbms_output.put_line('           ' || v_cursor2%rowcount || '. '|| nume_vin || ' ' ||  castig_vin);
        castig_producator := castig_producator + castig_vin;
      end loop;
      if castig_producator != 0 then
         dbms_output.put_line('         Castigul producatorului este de : ' || castig_producator);
      else
        dbms_output.put_line('          Producatorul nu a inregistrat niciun castig!');
      end if;
      castig_re := castig_re + castig_producator;
      dbms_output.new_line;
   end loop;
   if castig_re = 0 then
      dbms_output.put_line('     Regiune fara castig!');
   else dbms_output.put_line('   Castigul regiunii este de : ' || castig_re);
   end if;
   dbms_output.put_line('===========================');
end loop;
close castig_regiune;
end;
/

begin
  castiguri();
end;
/

-- Exercitiul 8

-- Am cautat toate vinurile care apartin tuturor planurilor care livreaza pachete intr-o zi a lunii mai mica decat o zi data 'given'
-- Ca argumente primesc ziua data, pretul pachetului pe care vreau sa il creez si un nested table in care
-- sa retin vinurile gasite; functia o sa returneze numarul de vinuri gasite
-- daca printre vinurile gasite am un vin care nu este in stoc, atunci pachetul nu poate fi format => exceptie => se afiseaza un mesaj corespunzator
-- si se returneaza 0; daca pretul total al vinurilor din presupusul pachet depaseste pretul dat ca parametru => exceptie (vrem sa avem profit!)
-- daca ziua introdusa nu este in intervalul [1,28] => exceptie

-- am tinut trei tipuri de variabile intr-un pachet
create or replace package find_wines_variables is
type r_wine_stock_price is record (stoc wines.stock%type,pret wines.price%type);
subtype zi is char(2);
type t_nes_wineids is table of wines.wineid%type;
end;
/


create or replace function find_wines(given in find_wines_variables.zi, pret_pachet in pls_integer, found_wines in out find_wines_variables.t_nes_wineids) return pls_integer
is
cursor c(given find_wines_variables.zi) is 
            (select distinct wineid
             from plan_wine pw
             where not exists(
                  (select planid
                    from plans p
                    where dayofmonth < given)
                    minus
                    (select p.planid
                    from plans p, plan_wine wp
                    where p.planid = wp.planid
                    and wp.wineid = pw.wineid)));
nr_found pls_integer := 0;
not_in_stock exception;
too_expensive exception;
pragma exception_init(too_expensive,-20001);
invalid_day exception;

empty_wines find_wines_variables.t_nes_wineids := find_wines_variables.t_nes_wineids();
wine_desc find_wines_variables.r_wine_stock_price;
total_price pls_integer := 0;
begin
--vrem sa vedem daca ziua data este valida
if '01'> given or given > '28' then
      raise invalid_day;
end if;

open c(given);
fetch c bulk collect into found_wines;
nr_found := c%rowcount;
close c;
begin
       --daca pretul unuia dintre vinuri > pretul pachetului => exceptie
       --daca unul din vinuri nu mai e in stoc => exceptie
       for i in 1..nr_found loop
           select stock, price
           into wine_desc
           from wines
           where wineid = found_wines(i);
           
           total_price := total_price + wine_desc.pret;
           if total_price > pret_pachet then 
                raise_application_error(-20001,'Pachetul propus nu are profit!');
           end if;
           if wine_desc.stoc = 0 then
               raise not_in_stock;
           end if;
       end loop;
    exception
    when not_in_stock then 
          raise;
    end;
return nr_found;

exception
when too_expensive then
     dbms_output.put_line(SQLERRM);
     return 0;
when not_in_stock then
     dbms_output.put_line('Produsele nu se afla in stoc!');
      return 0;
when invalid_day then
    dbms_output.put_line('Ziua data este invalida!');
    return 0;
when others then
    dbms_output.put_line('Exceptie!');
     return 0;
end;
/

declare
result find_wines_variables.t_nes_wineids ;
zi_corecta find_wines_variables.zi := '15';
zi_gresita find_wines_variables.zi := '45';
nr_wines pls_integer;
begin
    -- cazul in care avem exceptia invalid day
    dbms_output.put_line('Testul 1');
    nr_wines := find_wines(zi_gresita,100,result);
    if nr_wines != 0 then 
         dbms_output.put_line('The wines eligible for the new plan are: ');
         for i in 1..result.count loop
             dbms_output.put_line(result(i));
         end loop;
    end if;
    -- cazul in care pretul pachetului este depasit : too_expensive
     dbms_output.put_line('Testul 2');
    nr_wines := find_wines(zi_corecta,20,result);
    if nr_wines != 0 then 
         dbms_output.put_line('The wines eligible for the new plan are: ');
         for i in 1..result.count loop
             dbms_output.put_line(result(i));
         end loop;
    end if;
    -- nicio exceptie nu este intalnita
     dbms_output.put_line('Testul 3');
    nr_wines := find_wines(zi_corecta,100,result);
    dbms_output.put_line('Number of wines in the plan: ' || nr_wines);
       if nr_wines != 0 then 
         dbms_output.put_line('The wines eligible for the new plan are: ');
         for i in 1..result.count loop
             dbms_output.put_line(result(i));
         end loop;
    end if;
end;
/
--select wineid, dayofmonth,p.planid from plan_wine p join plans pw on p.planid = pw.planid;

-- Exercitiul 9


create or replace type t_orase is table of varchar2(25);
/

create or replace procedure pickup_points(firstcountry countries.countryname%type, secondcountry countries.countryname%type)
is                                
firstid countries.countryid%type;
secondid countries.countryid%type;
type t_regiuni is  table of float index by regions.regionname%type;
type rec_reg_ind is record (regiuni t_regiuni, tara countries.countryid%type);
type v_array is varray(3) of rec_reg_ind;
tablou_regiuni t_regiuni;
orase t_orase := t_orase();
id_tara countries.countryid%type;
tablou_complex v_array := v_array();
maxim pls_integer := 0;
ind regions.regionname%type;
regiune regions.regionid%type;
nextindex pls_integer := 1;
array_item1 rec_reg_ind;
array_item2 rec_reg_ind;
checking pls_integer :=0;
begin

  --cautam id-ul tarilor 
  begin
     select countryid
     into firstid
     from countries
     where lower(countryname) = lower(firstcountry);
  exception
     when no_data_found then
         raise_application_error(-20002,'Tara 1 nu exista!');
  end;
  
  begin
     select countryid
     into secondid
     from countries
     where lower(countryname) = lower(secondcountry);
   exception
     when no_data_found then
         raise_application_error(-20002,'Tara 2 nu exista!');
   end;
   
   array_item1.regiuni := tablou_regiuni;
   array_item2.regiuni := tablou_regiuni;
   array_item1.tara := firstid;
   array_item2.tara := secondid;
   tablou_complex.extend(2);
   tablou_complex(1) := array_item1;
   tablou_complex(2) := array_item2;
   
   for i in 1..2 loop
        
          for item in  (select r.regionid regiune, sum((floor(months_between(enddate,startdate))) * planprice) suma
                       from regions r  join addresses ad on ad.regionid = r.regionid join subscription s on s.deliveryaddress = ad.addressid join plans p 
                       on p.planid = s.planid
                       where lower(countryid) = lower(tablou_complex(i).tara)
                       group by r.regionid
                       order by 1) loop
            
            tablou_complex(i).regiuni(item.regiune) := item.suma;
        end loop;
   
    for item in (select r.regionid regiune, sum(totalprice) suma
                from regions r  join addresses ad on ad.regionid = r.regionid join orders ord on ord.deliveryaddress = ad.addressid
                where lower(countryid) = lower(tablou_complex(i).tara)
                group by r.regionid
                order by 1) loop
        
         if tablou_complex(i).regiuni.exists(item.regiune) then
             tablou_complex(i).regiuni(item.regiune) := item.suma + tablou_complex(i).regiuni(item.regiune);
         else 
             tablou_complex(i).regiuni(item.regiune) := item.suma;
         end if;
     end loop;
   
    maxim := 0;
    ind :=  tablou_complex(i).regiuni.first;
    while ind is not null loop
        if  tablou_complex(i).regiuni(ind) > maxim then
               maxim :=  tablou_complex(i).regiuni(ind);
               regiune:= ind;
        end if;
        ind := tablou_complex(i).regiuni.next(ind);
    end loop;
    
    for item in (select distinct city
                 from addresses
                 where regionid = regiune) loop
        orase.extend(1);
        orase(nextindex) := initcap(item.city);
        nextindex := nextindex + 1;
       
    end loop;
    --pregatim variabila regiune pentru urmatorul loop
    regiune := 0;
   end loop;
   
   for item in (select column_value nume
              from table(cast(orase as t_orase))
              order by column_value) loop
         dbms_output.put_line(item.nume);  
         checking := checking + 1;
   end loop;
   if checking = 0 then
         dbms_output.put_line('Niciun oras cu proprietatile cerute nu a fost gasit!');
   end if;
end;
/

begin
pickup_points('France','Switzerld');
end;
/

begin
pickup_points('France','Switzerland');
end;
/

begin
pickup_points('France','United States of America');
end;
/

-- Exercitiul 10

create or replace trigger plans_intervals
before
insert or update or delete or update on plans
begin
if updating and to_char(sysdate,'dd') != '01' then 
      raise_application_error(-20020,'Actualizarea unui plan este permisa doar in prima zii a lunii!'); 
end if;
if inserting and to_char(sysdate,'hh24') not between 12 and 23 then
     raise_application_error(-20021,'Nu poti insera un plan daca nu esti in intervalul orelor de varf!');
end if;
if deleting then
     raise_application_error(-20023,'Nu poti sterge inregistrari din tabela plans!');
end if;
end;
/


insert into plans
values(7,'Some','Desc',22.1,'02',2);

update plans
set description = 'Anot'
where planid = 7;

delete from plans
where planid = 7;


alter trigger plans_intervals disable;
delete from plans
where planid = 7;
alter trigger plans_intervals enable;


--desc plan_wine;
--insert into plan_wine
--values(30,7,1,'1-JAN-2021');

-- Exercitiul 11


create or replace trigger compound_trigger_winestore
for insert or  update or delete on plan_wine
compound trigger
day find_wines_variables.zi;
before each row is
begin
if updating then
    select dayofmonth
    into day
    from plans
    where planid = :OLD.planid;
    if sysdate not between (:OLD.period + to_number(day) - 1) and (add_months(:OLD.period + to_number(day) - 2,1)) then
           raise_application_error(-20002,'Nu poti sa schimbi un pachet care a fost deja livrat!');
    end if;
end if;
end before each row;
end;
/

update plan_wine
set wineid = 5
where planwineid = 2;

--update plan_wine
--set wineid = 2
--where planwineid = 30;


-- Exercitiul 12



create table safe_info_2
( db_name varchar2(100),
  logged_user varchar2(50),
  event varchar2(100),
  referenced_object varchar2(50),
  referenced_object_name varchar2(50),
  time timestamp(3));


create or replace TRIGGER safe_db
after create or alter on schema
BEGIN
if ora_sysevent = 'CREATE' then
  dbms_output.put_line('Ai creat un nou obiect de tipul ' ||
  ORA_DICT_OBJ_TYPE || ' cu numele ' ||
  ORA_DICT_OBJ_NAME);
end if;
if ora_sysevent = 'ALTER' and ora_dict_obj_type = 'TABLE' and ora_dict_obj_name = 'MEMBERS' then
       dbms_output.put_line('Atentie! Ati modificat tabela Members!');
end if;
insert into safe_info_2
values(sys.database_name, sys.login_user, ora_sysevent, ora_dict_obj_type,
ora_dict_obj_name,  systimestamp(3));
END;
/

select * from safe_info_2;

ALTER TABLE members
ADD placeofbirth varchar(255);

select * from safe_info_2;

alter table members
drop column placeofbirth;

-- Exercitiul 13

create or replace package winestore is
subtype nume_vin is varchar2(40);
subtype zi is char(2);
type t_nes_wineids is table of wines.wineid%type;
type r_wine is record (nume wines.winename%type, pret wines.price%type);
type r_wine_stock_price is record (stoc wines.stock%type,pret wines.price%type);
type t_price is table of r_wine;
type t_orders is table of natural index by nume_vin;
type t_prices is table of float index by nume_vin;
type t_wineids is table of natural index by nume_vin;

procedure changeprices(producator IN producers.producerid%type);
procedure castiguri;
function find_wines(given in zi, pret_pachet in pls_integer, found_wines in out t_nes_wineids) return pls_integer;
procedure pickup_points(firstcountry countries.countryname%type, secondcountry countries.countryname%type);
end;
/

create or replace package body winestore is
-- Exercitiul 6
procedure changeprices(producator IN producers.producerid%type) is
--pret_minim = pretul la care ne raportam
pret_minim pls_integer;
type t_wines is table of wines.wineid%type;
wine_taken t_wines := t_wines();
updated_price t_price;
nr pls_integer;
no_producer exception;
pragma exception_init(no_producer,-20030);
begin
--aflam pretul in raport cu care o sa schimbam preturile vinurilor
select count(*) into nr from producers where producerid = producator;
if nr = 0 then 
   raise_application_error(-20030,'Nu exista un producator cu acest id!');
end if;
select max(min(price))
into pret_minim
from wines
group by producerid;

----colectam toate vinurile cu proprietatea ceruta
select wineid
bulk collect into wine_taken
from wines
where producerid = producator
and price <= pret_minim;

if wine_taken.count = 0 then
    dbms_output.put_line('Niciun vin al producatorului dat nu respecta proprietatea ceruta!');
else
    ---- actualizam preturile tuturor vinurilor luate in considerare,
    ---- retinem, de asemenea, preturile noi si denumirile vinurilor modificate
    forall ind in 1..wine_taken.count 
          update wines
          set price = price*10/100 + pret_minim
          where wineid = wine_taken(ind)
          returning winename,price bulk collect into updated_price;
    
    dbms_output.put_line('Numele si preturile noi sunt :');
    for i in 1..(updated_price.count) loop
       dbms_output.put_line(updated_price(i).nume || ' ' || updated_price(i).pret);
    end loop;
end if;
exception
when no_producer then
   dbms_output.put_line('Nu exista un producator cu id-ul dat!');
when others then
   dbms_output.put_line('Eroare!');
end changeprices;
--Exercitiul 7
procedure castiguri is
cursor castig_regiune
is select regionname, 
          cursor(select producername, cursor(
                    select max(winename), sum(orderprice*quantity) as castig_vin
                    from wines w join order_wine ow on ow.wineid = w.wineid
                    where w.producerid = p.producerid 
                    group by w.wineid
                    order by castig_vin desc)
          from producers p
          where p.regionid = r.regionid)
    from regions r;
v_cursor1 sys_refcursor;
v_cursor2 sys_refcursor;
nume_regiune regions.regionname%type;
nume_producator producers.producername%type;
nume_vin wines.winename%type;
castig_vin float := 0;
castig_producator float := 0;
castig_re float := 0;
begin
open castig_regiune;
loop
   fetch castig_regiune into nume_regiune,v_cursor1;
   exit when castig_regiune%notfound;
   castig_re := 0;
   dbms_output.put_line(' x  Pentru regiunea: ' || nume_regiune);
   --cursor secundar: producator
   loop
      fetch v_cursor1 into nume_producator, v_cursor2;
      exit when v_cursor1%notfound;
      castig_producator := 0;
      dbms_output.put_line('       xx Pentru producatorul : ' || nume_producator);
      -- al treilea cursor: vinuri
      loop
        fetch v_cursor2 into nume_vin, castig_vin;
        exit when v_cursor2%notfound;
            dbms_output.put_line('           ' || v_cursor2%rowcount || '. '|| nume_vin || ' ' ||  castig_vin);
        castig_producator := castig_producator + castig_vin;
      end loop;
      if castig_producator != 0 then
         dbms_output.put_line('         Castigul producatorului este de : ' || castig_producator);
      else
        dbms_output.put_line('          Producatorul nu a inregistrat niciun castig!');
      end if;
      castig_re := castig_re + castig_producator;
      dbms_output.new_line;
   end loop;
   if castig_re = 0 then
      dbms_output.put_line('     Regiune fara castig!');
   else dbms_output.put_line('   Castigul regiunii este de : ' || castig_re);
   end if;
   dbms_output.put_line('===========================');
end loop;
close castig_regiune;
end;
-- Exercitiul 8
function find_wines(given in zi, pret_pachet in pls_integer, found_wines in out t_nes_wineids) return pls_integer
is
cursor c(given zi) is 
            (select distinct wineid
             from plan_wine pw
             where not exists(
                  (select planid
                    from plans p
                    where dayofmonth < given)
                    minus
                    (select p.planid
                    from plans p, plan_wine wp
                    where p.planid = wp.planid
                    and wp.wineid = pw.wineid)));
nr_found pls_integer := 0;
not_in_stock exception;
too_expensive exception;
pragma exception_init(too_expensive,-20001);
invalid_day exception;

empty_wines t_nes_wineids := t_nes_wineids();
wine_desc r_wine_stock_price;
total_price pls_integer := 0;
begin
--vrem sa vedem daca ziua data este valida
if '01'> given or given > '28' then
      raise invalid_day;
end if;

open c(given);
fetch c bulk collect into found_wines;
nr_found := c%rowcount;
close c;
begin
       --daca pretul unuia dintre vinuri > pretul pachetului => exceptie
       --daca unul din vinuri nu mai e in stoc => exceptie
       for i in 1..nr_found loop
           select stock, price
           into wine_desc
           from wines
           where wineid = found_wines(i);
           
           total_price := total_price + wine_desc.pret;
           if total_price > pret_pachet then 
                raise_application_error(-20001,'Pachetul propus nu are profit!');
           end if;
           if wine_desc.stoc = 0 then
               raise not_in_stock;
           end if;
       end loop;
    exception
    when not_in_stock then 
          raise;
    end;
return nr_found;

exception
when too_expensive then
     dbms_output.put_line(SQLERRM);
     return 0;
when not_in_stock then
     dbms_output.put_line('Produsele nu se afla in stoc!');
      return 0;
when invalid_day then
    dbms_output.put_line('Ziua data este invalida!');
    return 0;
when others then
    dbms_output.put_line('Exceptie!');
     return 0;
end;
-- Exercitiul 9
procedure pickup_points(firstcountry countries.countryname%type, secondcountry countries.countryname%type)
is                                
firstid countries.countryid%type;
secondid countries.countryid%type;
type t_regiuni is  table of float index by regions.regionname%type;
type rec_reg_ind is record (regiuni t_regiuni, tara countries.countryid%type);
type v_array is varray(3) of rec_reg_ind;
tablou_regiuni t_regiuni;
orase t_orase := t_orase();
id_tara countries.countryid%type;
tablou_complex v_array := v_array();
maxim pls_integer := 0;
ind regions.regionname%type;
regiune regions.regionid%type;
nextindex pls_integer := 1;
array_item1 rec_reg_ind;
array_item2 rec_reg_ind;
checking pls_integer :=0;
begin

  --cautam id-ul tarilor 
  begin
     select countryid
     into firstid
     from countries
     where lower(countryname) = lower(firstcountry);
  exception
     when no_data_found then
         raise_application_error(-20002,'Tara 1 nu exista!');
  end;
  
  begin
     select countryid
     into secondid
     from countries
     where lower(countryname) = lower(secondcountry);
   exception
     when no_data_found then
         raise_application_error(-20002,'Tara 2 nu exista!');
   end;
   
   array_item1.regiuni := tablou_regiuni;
   array_item2.regiuni := tablou_regiuni;
   array_item1.tara := firstid;
   array_item2.tara := secondid;
   tablou_complex.extend(2);
   tablou_complex(1) := array_item1;
   tablou_complex(2) := array_item2;
   
   for i in 1..2 loop
        
          for item in  (select r.regionid regiune, sum((floor(months_between(enddate,startdate))) * planprice) suma
                       from regions r  join addresses ad on ad.regionid = r.regionid join subscription s on s.deliveryaddress = ad.addressid join plans p 
                       on p.planid = s.planid
                       where lower(countryid) = lower(tablou_complex(i).tara)
                       group by r.regionid
                       order by 1) loop
            
            tablou_complex(i).regiuni(item.regiune) := item.suma;
        end loop;
   
    for item in (select r.regionid regiune, sum(totalprice) suma
                from regions r  join addresses ad on ad.regionid = r.regionid join orders ord on ord.deliveryaddress = ad.addressid
                where lower(countryid) = lower(tablou_complex(i).tara)
                group by r.regionid
                order by 1) loop
        
         if tablou_complex(i).regiuni.exists(item.regiune) then
             tablou_complex(i).regiuni(item.regiune) := item.suma + tablou_complex(i).regiuni(item.regiune);
         else 
             tablou_complex(i).regiuni(item.regiune) := item.suma;
         end if;
     end loop;
   
    maxim := 0;
    ind :=  tablou_complex(i).regiuni.first;
    while ind is not null loop
        if  tablou_complex(i).regiuni(ind) > maxim then
               maxim :=  tablou_complex(i).regiuni(ind);
               regiune:= ind;
        end if;
        ind := tablou_complex(i).regiuni.next(ind);
    end loop;
    
    for item in (select distinct city
                 from addresses
                 where regionid = regiune) loop
        orase.extend(1);
        orase(nextindex) := initcap(item.city);
        nextindex := nextindex + 1;
       
    end loop;
    --pregatim variabila regiune pentru urmatorul loop
    regiune := 0;
   end loop;
   
   for item in (select column_value nume
              from table(cast(orase as t_orase))
              order by column_value) loop
         dbms_output.put_line(item.nume);  
         checking := checking + 1;
   end loop;
   if checking = 0 then
         dbms_output.put_line('Niciun oras cu proprietatile cerute nu a fost gasit!');
   end if;
end;
end;
/

-- verificari pentru ex. 7
begin
  winestore.castiguri();
end;
/


-- pentru ex. 8
declare
result winestore.t_nes_wineids ;
zi_corecta winestore.zi := '15';
zi_gresita winestore.zi := '45';
nr_wines pls_integer;
begin
    -- cazul in care avem exceptia invalid day
    dbms_output.put_line('Testul 1');
    nr_wines := winestore.find_wines(zi_gresita,100,result);
    if nr_wines != 0 then 
         dbms_output.put_line('The wines eligible for the new plan are: ');
         for i in 1..result.count loop
             dbms_output.put_line(result(i));
         end loop;
    end if;
    -- cazul in care pretul pachetului este depasit : too_expensive
     dbms_output.put_line('Testul 2');
    nr_wines := winestore.find_wines(zi_corecta,20,result);
    if nr_wines != 0 then 
         dbms_output.put_line('The wines eligible for the new plan are: ');
         for i in 1..result.count loop
             dbms_output.put_line(result(i));
         end loop;
    end if;
    -- nicio exceptie nu este intalnita
     dbms_output.put_line('Testul 3');
    nr_wines := winestore.find_wines(zi_corecta,100,result);
    dbms_output.put_line('Number of wines in the plan: ' || nr_wines);
       if nr_wines != 0 then 
         dbms_output.put_line('The wines eligible for the new plan are: ');
         for i in 1..result.count loop
             dbms_output.put_line(result(i));
         end loop;
    end if;
end;
/

-- verificari pentru ex. 9

begin
winestore.pickup_points('France','Switzerld');
end;
/

begin
winestore.pickup_points('France','Switzerland');
end;
/

begin
winestore.pickup_points('France','United States of America');
end;
/

-- Exercitiul 14

create sequence order_ids
start with 25 
increment by 1;
set serveroutput on;


--crearea pachetului
create or replace package winestore_orders 
is
subtype adresa is addresses.addressid%type;
subtype card is creditcards.cardid%type;
type t_addresses is table of adresa;
type t_cards is table of card;
procedure add_order(make_order winestore.t_orders, nume members.lastname%type, prenume members.firstname%type);
cursor c_card (membru_id members.memberid%type) is (select cardid from creditcards
                                                   where memberid = membru_id);      
no_member exception;
no_credit_card exception;
no_address exception;
not_in_stock exception;
n_mem pls_integer;
n_adr pls_integer;
n_card pls_integer;
stoc pls_integer;
end;
/
--crearea body-ului
create or replace package body winestore_orders
is
function get_address(membru_id members.memberid%type) return adresa
is
id_adresa addresses.addressid%type;
ind pls_integer;
maxim_frecventa pls_integer;
c_index pls_integer := 0;
adrese_randomizate t_addresses := t_addresses();
begin
--verificam sa existe adrese corespunzatoare membrului
select count(*)
into n_adr
from addresses
where memberid = membru_id
and addressid in (select deliveryaddress from orders where memberid = membru_id);
if n_adr = 0 then
   raise no_address;
end if;

-- gasim adresa pe care au fost livrate cele mai multe comenzi ale membrului respectiv de pana acum
-- daca adresele au aceeasi frecventa, se ia una random dintre acestea
select max(count(*)) 
into maxim_frecventa
from orders
where memberid = membru_id
group by deliveryaddress;

for item in (select max(deliveryaddress) as cod, count(*) as nr
            from orders
            where memberid = membru_id
            group by deliveryaddress
            order by 2 desc) loop
   if item.nr = maxim_frecventa then
              adrese_randomizate.extend;
              c_index := c_index + 1;
              
              adrese_randomizate(c_index) := item.cod; 
   end if;
   exit when maxim_frecventa > item.nr;
end loop;


ind := dbms_random.value(1,adrese_randomizate.count);
return adrese_randomizate(ind);
exception
when no_address then
    raise_application_error(-20001,'Clientul dat nu a are o adresa de livrare in folosinta!');
    return 0;
end;

function find_member(nume members.lastname%type, prenume members.firstname%type) return members.memberid%type
is
id_membru members.memberid%type;
begin
select memberid
into id_membru
from members
where lower(lastname) = lower(nume)
and lower(firstname) = lower(prenume);
return id_membru;
exception
when no_data_found then
   raise_application_error(-20005,'Nu exista un membru cu numele dat!');
when too_many_rows then
   raise_application_error(-20004,'Exista mai multi membrii cu numele dat!');
when others then
  raise_application_error(-20002,'Eroare!');
end;

                             
function get_creditcard(membru_id members.memberid%type) return creditcards.cardid%type
is
randomized_cards t_cards := t_cards();
ind pls_integer;
begin
open c_card(membru_id);
fetch c_card bulk collect into randomized_cards;
if randomized_cards.count = 0 then
      close c_card;
      raise no_credit_card;
end if;
ind := dbms_random.value(1,c_card%rowcount);
close c_card;
return randomized_cards(ind);
exception
when no_credit_card then
    raise_application_error(-20008,'Nu exista card!');
end;

function get_discount(wine_id wines.wineid%type) return discounts.percentage%type
is
reducere float := 0; 
nr_dis_active pls_integer;
begin
    select count(*)
    into nr_dis_active
    from discounts d join wine_discount dw 
    on d.discountid = dw.discountid join wines w on dw.wineid = w.wineid
    where w.wineid = wine_id and sysdate between startdate and enddate;
--    -- ne uitam in discounts si wine_discount sa vedem daca vinul este redus si, in acest caz, sa
--    -- preluam valoarea discount-ului in variabila reducere
    if nr_dis_active != 0 then 
        select sum(percentage)
        into reducere
        from discounts d join wine_discount dw 
        on d.discountid = dw.discountid join wines w on dw.wineid = w.wineid
        where w.wineid = wine_id and sysdate between startdate and enddate
        group by w.wineid;
    end if;
return reducere;
end;
function find_wine(nume wines.winename%type) return wines.wineid%type
is
id_vin wines.wineid%type;
begin
select wineid
into id_vin
from wines
where lower(winename) = lower(nume); 
return id_vin;
exception
when no_data_found then
   raise_application_error(-20005,'Nu exista un vin cu numele ' || nume);
when too_many_rows then
   raise_application_error(-20004,'Exista mai multe vinuri cu numele ' || nume);
when others then
  raise_application_error(-20002,'Eroare!');
end;

function check_stock(wine_id wines.wineid%type, cantitate pls_integer) return boolean
is
stoc pls_integer;
begin
    select stock
    into stoc
    from wines
    where wineid = wine_id;
    if stoc < cantitate then 
        return false;
    end if;
return true;
end;
procedure add_order(make_order winestore.t_orders, nume members.lastname%type, prenume members.firstname%type)
is
order_wine_price winestore.t_prices;
wine_ids winestore.t_wineids;
total_price float := 0;
total_discount float := 0;
reducere float := 0;
pret float;
adresa_gasita adresa;
membru_id members.memberid%type;
card_id card;
id_vin wines.wineid%type;
i_first winestore.nume_vin;
cantitate pls_integer;
order_id natural;
in_stock boolean;
begin
--cautam memberul
membru_id := find_member(nume,prenume);
--- cautam adresa si cardul 
adresa_gasita := get_address(membru_id);
card_id := get_creditcard(membru_id);
i_first := make_order.first;
while i_first is not null loop

     id_vin := find_wine(i_first);
     cantitate := make_order(i_first);
    --prima oara trebuie sa ne asiguram ca produsul este in stoc
    -- daca nu este in stoc => exceptie (comanda nu se poate realiza)
     in_stock := check_stock(id_vin,cantitate);
     if in_stock = false then
          raise not_in_stock;
     end if;
     dbms_output.put_line(i_first || ' ' || id_vin || ' cantitate: ' || cantitate);
    --vrem sa vedem daca avem vreun discount
    reducere := get_discount(id_vin);
    --luam pretul
    select price
    into pret
    from wines
    where wineid = id_vin;
    
    -- calculam pretul vinului pentru comanda actuala 
    -- retinem intr-un tabel indexat id-ul vinurilor (o sa avem nevoie pentru a introduce detaliile comenzii in order_wine)
    wine_ids(i_first) := id_vin;
    order_wine_price(i_first) := pret*(100 - reducere)/100;
    total_price := total_price +  cantitate * order_wine_price(i_first);
    total_discount := total_discount + cantitate*pret*reducere/100;

    i_first := make_order.next(i_first);
end loop;

-- inseram noua comanda in tabelul orders:
order_id := order_ids.nextval;
insert into orders
values(order_id,sysdate,null,adresa_gasita,adresa_gasita,total_price,total_discount,card_id,membru_id);

-- inseram informatiile produselor in tabelul order_wine:
i_first := order_wine_price.first;
while i_first is not null loop
    insert into order_wine
    values(order_id,wine_ids(i_first), make_order(i_first), order_wine_price(i_first));
    i_first := order_wine_price.next(i_first);
end loop;

exception
when not_in_stock  then
     dbms_output.put_line('Produsul nu este in stoc!');
when others then
   dbms_output.put_line('A intervenit o eroare: ' || SQLERRM);
end;
end;
/

declare
make_ord winestore.t_orders;
begin
make_ord('Krondorf Shiraz') := 2;
make_ord('Art Series Riesling') := 20;
make_ord('Cabernet Sauvignon Shiraz') := 1;
winestore_orders.add_order(make_ord, 'Robinson','Tate');
end;
/

--rollback;
--select * from orders;
--select * from order_wine;




