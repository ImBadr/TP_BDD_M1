-- 1. Un employé ne peut pas travailler sur un projet qui n'appartient pas à son département   
create or replace trigger question1
before insert or update on travaille
for each row
declare 
    projdep int;
    empdep int;
begin
    select numdep into projdep from projet where numprj = :new.numprj;
    select numdep into empdep from employe where matricule = :new.matricule;
    if projdep != empdep then 
        raise_application_erorr(20001,'erreur');
    end if;
end;
/

-- 2. Supposons  qu'il  existe  une  règle  dans  l'entreprise  stipulant  que  le  salaire  d'un  employé  ne  peut 
-- pas  être  modifié  de  plus  de  20%  du  salaire  initial.  Créez  un  trigger  'Suivi_changements_salaire' 
-- pour faire respecter cette contrainte.   
create or replace trigger Suivi_changements_salaire
before update on employe 
for each row
begin
    if ( :new.salaire > ( :old.salaire * 1.20 )) then
        raise_application_erorr(20001,'erreur');
    end if;
end;
/

-- 3. Une fois qu'un département est créé, nous ne pouvons pas changer son nom ou le supprimer.   
create or replace trigger edit_name_departement
before update or delete on departement
for each row 
begin
    if DELETING then
        raise_application_erorr(20001,'erreur');
    end if;

    if UPDATING then
        if :old.nomdep != :new.nomdep then
            raise_application_erorr(20001,'erreur');
        end if;
    end if;
end;
/

-- 4. Un employé ne peut pas travailler plus de 200 heures. 
create or replace trigger not_more_than_200_hours
before insert or update on travaille
for each row
declare
    nbhours int;
begin
    select sum(heures) into nbhours from travaille where matricule = :new.matricule;
    
    if INSERTING then
        if nbhours + :new.heures > 200 then
            raise_application_erorr(20001,'erreur');
        end if;
    end if;

    if UPDATING then
        if nbhours - :old.heures + :new.heures > 200 then
            raise_application_erorr(20001,'erreur');
        end if;
    end if;
    
end;
/