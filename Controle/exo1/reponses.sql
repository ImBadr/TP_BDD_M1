--1. �crire une proc�dure qui prend comme arguments un identifiant d'employ� et un nombre, puis
--mettre � jour le salaire de l'employ� donn� avec le nombre donn�. Nombre = 500�.
create or replace procedure majsalaire (id int, nombre int)
as begin
    update employe set salaire = salaire + nombre where numemp = id;
end;
/

--2. �crire une fonction qui compte le nombre d'employ�s participant � un projet donn�.
create or replace function countemployes (idproj int)
return number
is
    nb int;
begin
    select count(*) into nb from travail where numproj = idproj;
    return nb;
end;
/

--3. �crire une fonction qui compte le nombre de projets supervis�s par les employ�s d'un service donn�.
create or replace function count_project_suervises (numserv int)
return int
is
    nb int;
begin
    select count(p) into nb from projet p, employe e where p.resp = e.numemp and e.affect = numserv;
    return nb;
end;
/

--4. �crire une fonction qui compte le nombre de Liens de base de donn�es projets auxquels participe l'employ� donn�.
create or replace function count_projet_emp (idemp int)
return int
is
    nb int;
begin
    select count(*) into nb from travail where numemp = idemp;
    return nb;
end;
/

--5. �crire une fonction qui renvoie la cha�ne 'Salaire faible' si le salaire de l'employ� donn� est inf�rieur � 2000� sinon retourner 'Bon salaire'.
create or replace function salaire_statut (salaire int)
return varchar
is
begin
    if salaire < 2000 then
        return 'Salaire faible';
    else
        return 'bon salaire';
    end if;
end;
/

--6. �crire une fonction, qui compte le nombre d'employ�s qui prennent en charge plus que le nombre de projets donn�.
create or replace function count_employe_responsable (nbproj int)
return int
is
    nb int;
begin
    select count(*) into nb from employe e where (select count(*) from projet p where e.numemp = p.resp) > nbproj;
    return nb;
end;
/

--7. �crire une proc�dure qui ins�re l'employ� donn� dans une table de sauvegarde nomm�e 'ALERT_EMPLOYE'.
create or replace procedure insert_employe (emp employe%rowtype)
as begin
    insert into ALERT_EMPLOYE values (emp.numemp, emp.nomemp, emp.hebdo, emp.salaire, emp.affect);
end;
/
