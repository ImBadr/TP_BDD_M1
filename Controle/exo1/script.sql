------ DROP TABLES ------
drop table employe cascade constraints;
drop table service cascade constraints;
drop table projet cascade constraints;
drop table travail cascade constraints;

--Service(NumServ:integer, NomServ:string, #chef:integer)
create table service (
    numserv int primary key not null,
    nomserv varchar(255),
    chef int
);

--Employe(NumEmp:string, NomEmp:string, Hebdo:integer, Salaire:integer, #affect:integer)
create table employe (
    numemp int primary key not null,
    nomemp varchar(255),
    hebdo int,
    salaire int,
    affect int
);

--Projet(NumProj:integer, NomProj:string, #Resp:integer)
create table projet (
    numproj int primary key not null,
    nomproj varchar(255),
    resp int
);

--Travail(#NumEmp:integer, #NumProj:integer, Duree:integer)
create table travail (
    numemp int,
    numproj int,
    duree int,
    constraint pk_travail primary key (numemp, numproj)
);

alter table service add constraint fk_chef foreign key (chef) references employe(numemp);
alter table employe add constraint fk_affect foreign key (affect) references service(numserv);
alter table projet add constraint fk_resp foreign key (resp) references employe(numemp);
alter table travail add constraint fk_numemp foreign key (numemp) references employe(numemp);
alter table travail add constraint fk_numproj foreign key (numproj) references projet(numproj);
