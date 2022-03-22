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
