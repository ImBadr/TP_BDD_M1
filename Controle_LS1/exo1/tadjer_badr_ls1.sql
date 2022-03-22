-- TADJER BADR LS1

drop table typea cascade constraints;
drop table avion cascade constraints;
drop table expertise cascade constraints;
drop table expert cascade constraints;
drop table pilote cascade constraints;
drop table vol cascade constraints;
drop table test cascade constraints;

--TypeA(idType :Integer, nom :Varchar2, poids :integer, capacite :integer) 
create table typea (
    idtype int primary key not null,
    nom varchar2(255),
    poids int,
    capacite int
);

--Avion(numeroAvion : Integer, localisaion : Varchar2, #idType : Integer) 
create table avion (
    numeroavion int primary key not null,
    localisation varchar2(255),
    idtype int
);

--Expertise(#matriculeExpert : Integer, #idType : Integer, dateDebut : date, DateFin : date) 
create table expertise (
    matriculeexpert int,
    idtype int,
    datedebut date,
    datefin date,
    constraint pk_expertise primary key (matriculeexpert, idtype)
);

--Expert(matriculeExpert: Integer, nom : Varchar2, adresse : Varchar2, tel : Varchar2, salaire:integer) 
create table expert (
    matriculeexpert int primary key not null,
    nom varchar2(255),
    adresse varchar2(255),
    tel varchar2(255),
    salaire int
);

--Pilote(matriculePilote : integer, nom : varchar2, adresse : varchar2, tel :varchar2, salaire :integer, examenMedical :date) 
create table pilote (
    matriculepilote int primary key not null,
    nom varchar2(255),
    adresse varchar2(255),
    tel varchar2(255),
    salaire int,
    examenmedical date
);

--Vol(numeroVol, #numeroAvion, #MatriculePilote, villeDep, VilleArr, hDep, hArr, dureePrevue) 
create table vol (
    numerovol int,
    numeroavion int,
    matriculepilote int,
    villedep varchar2(255),
    villearr varchar2(255),
    hdep date,
    harr date,
    dureeprevue int,
    constraint pk_vol primary key (numeroavion, matriculepilote)
);

--Test (numeroTest : integer, type : integer, seuil : integer, datetest :date, etat : varchar2, #numeroAvion : Integer)
create table test (
    numerotest int,
    type int,
    seuil int,
    datetest date,
    etat varchar2(255),
    numeroavion int
);

alter table avion add constraint fk_idtype_avion foreign key (idtype) references typea(idtype);
alter table expertise add constraint fk_matriculeexpert foreign key (matriculeexpert) references expert(matriculeexpert);
alter table expertise add constraint fk_idtype_expertise foreign key (idtype) references typea(idtype);
alter table vol add constraint fk_numeroavion foreign key (numeroavion) references avion(numeroavion);
alter table vol add constraint fk_matriculepilote foreign key (matriculepilote) references pilote(matriculepilote);
alter table test add constraint fk_numeroavion_test foreign key (numeroavion) references avion(numeroavion);


--1. Ecrire  une  fonction  qui  compte  le  nombre  de  pilotes  qui  ont  conduit  des  vols  �  la destination de �Nantes�.
create or replace function count_vol_nantes
return int
is
begin
    select count(distinct matriculepilote) from pilote 
    join vol on pilote.matriculepilote = vol.matriculepilote 
    where villearr = 'Nantes';
end;
/

--2. Ecrire une proc�dure qui prend comme arguments un matricule d�expert et un nombre, puis mettre � jour le salaire de l�expert donn� avec le nombre donn�. Nombre 700euro.
create or replace procedure update_salaire (matriculeexp int, nb int)
as begin
    update expert set salaire = nb where matriculeexpert = matriculeexp;
end;
/

--3. Ecrire une fonction qui compte le nombre de vols vers Toulouse via le type d�avion �Boing 747�. 
create or replace function count_vol_toulouse 
return int
is
    nb int;
begin
    select count(*) from vol 
    join avion on vol.numeroavion = avion.numeroavion
    join typea on avion.idtype = typea.idtype
    where vol.villearr = 'Toulouse' and typea.nom = 'Boing 747';
end;
/

--4. Ecrire  une  fonction  qui  compte  le  nombre  d�avion  ayant  la  capacit�  sup�rieur  �  100 voyageurs. 
create or replace function count_nb_avion
return int
is
    nb int;
begin
    select count(*) into nb from avion
    join typea on avion.idtype = typea.idtype
    where typea.capacite > 100;
    return nb;
end;
/

--5. Ecrire une fonction qui compte le nombre des tests pour l�avion �Boing777�. 
create or replace function count_nb_test
return int
is
    nb int;
begin
    select count(*) into nb from test 
    join avion on test.numeroavion = avion.numeroavion
    join typea on avion.idtype = typea.idtype
    where typea.non = 'Boing777';
    return nb;
end;
/

--6. Ecrire  une proc�dure qui affiche pour un nom de type d�avion pass� en param�tre : L��tat du dernier test r�alis� sur chacun des avions du type choisi et le nom de l�expert responsable le jour de ce test.
create or replace procedure affiche_etat_test (nomtypeavion typea.nom%type)
as
    status test%rowtype;
begin
    for avion in (select * from avion join typea on avion.idtype = typea.idtype where typea.nom = nomtypeavion)
    loop
        select * into status from (
            select * from test where test.numeroavion = avion.numeroavion
            order by datetest desc
        ) where rownum = 1;
        DBMS_OUTPUT.PUT_LINE(status.etat);
    end loop;
end;
/

--7. Ecrire une proc�dure qui affiche pour un nom de type d�avion pass� en param�tre : Le pourcentage des avions qui ne sont pas en bon �tat. (L�attribut etat peut avoir deux valeurs : �bon� et �mauvais�)
create or replace procedure affiche_avion (nomtypeavion typea.nom%type)
as
    mauvais int;
    total int;
    pourcentage int;
begin
    select count() into mauvais from avion
    join test on test.numeroavion = avion.numeroavion
    join typea on avion.idtype = typea.idtype
    where typea.nom = nomtypeavion and test.etat = 'mauvais';

    select count() into total from avion
    join typea on avion.idtype = typea.idtype
    where typea.nom = nomtypeavion;

    pourcentage := (mauvais/total) * 100;
    DBMS_OUTPUT.PUT_LINE(pourcentage);
end;
/

--8. Une proc�dure qui affiche toutes les informations sur les vols partants d�une ville pass�e en param�tre, allant vers une ville �galement pass�e en param�tre et arrivant en retard.
create or replace procedure affiche_info_vol (villededepart vol.villedep%type, villedearrivee vol.villearr%type)
as
begin
    for vols in (select * from vol where vol.villedep = villededepart and vol.villarr = villedearrivee) loop
        if vols.hdep + vols.dureeprevue > harr then
            DBMS_OUTPUT.PUT_LINE(vols);
        end if;
    end loop;
end;
/

--9. Ecrire deux triggers : 
--a. �TRIG_INS� qui v�rifie avant l�insertion d�un vol que le pilote n�a pas des vols pendant la p�riode entre l�heure de d�part et l�heure d�arriv�e. Sinon lancer une exception avec un message appropri�. 


--b. �TRIG_STATIS� qui enregistre les diff�rentes op�rations de mise � jour faites sur la table Vol dans une table d�archive.

