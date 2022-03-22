------ DROP TABLES ------
drop table departement cascade constraints;
drop table employe cascade constraints;
drop table projet cascade constraints;
drop table travaille cascade constraints;

-- Departement (NumDep, NomDep, Directeur) 
create table departement (
    numdep int primary key not null,
    nomdep varchar(255),
    directeur varchar(255)
);

-- Employe (Matricule, Nom, Prenom, DateNaissance, Adresse, Salaire, #Numdep, #superieur) 
create table employe (
    matricule int primary key not null,
    nom varchar(255),
    prenom varchar(255),
    datenaissance date,
    adresse varchar(255),
    salaire int,
    numdep int,
    superieur int
);

-- Projet (NumPrj, NomPrj, Lieu, #NumDep) 
create table projet (
    numprj int primary key not null,
    nomprj varchar(255),
    lieu varchar(255),
    numdep int
);

-- Travaille (#Matricule, #NumPrj, Heures)
create table travaille (
    matricule int,
    numprj int,
    heures int,
    contraints pk_travaille primary key (matricule, numprj)
);

alter table employe add contraints fk_numdep foreign key (numdep) references departement(numdep);
alter table employe add contraints fk_superieur foreign key (superieur) references employe(matricule);
alter table projet add contraints fk_numdep_projet foreign key (numdep) references departement(numdep);