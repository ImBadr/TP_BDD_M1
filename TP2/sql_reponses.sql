-- EMPLOYES(refemp, nom, prenom, salTot, NbProjet);
-- PROJET(refproj, #refemp, nomp, nbheuresprevues, nbheureseffectuees, budget) ; 
-- PARTICIPE (#refproj, #refemp, dateP )
-- TACHE(#refproj, #refemp, semaine , nbheures);

---------C##Badr
-- TP2 --
---------password

-----------------
-- DROP TABLES --
-----------------
DROP TABLE EMPLOYES CASCADE CONSTRAINTS;
DROP TABLE PROJET CASCADE CONSTRAINTS;
DROP TABLE PARTICIPE CASCADE CONSTRAINTS;
DROP TABLE TACHE CASCADE CONSTRAINTS;
DROP TABLE TAB_LOG CASCADE CONSTRAINTS;
DROP TABLE LOG CASCADE CONSTRAINTS;
DROP SEQUENCE tab_log_seq;
DROP SEQUENCE log_seq;

-------------------
-- CREATE TABLES --
-------------------
CREATE TABLE EMPLOYES (
    refemp INT PRIMARY KEY NOT NULL,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    salTot INT,
    NbProjet INT
);
CREATE TABLE PROJET (
    refproj INT PRIMARY KEY NOT NULL,
    refemp INT,
    nomp VARCHAR(100),
    nbheuresprevues INT,
    nbheureseffectuees INT,
    budget INT,
    FOREIGN KEY (refemp) REFERENCES EMPLOYES(refemp)
);
CREATE TABLE PARTICIPE (
    refproj INT,
    refemp INT,
    dateP DATE,
    CONSTRAINT P_PARTICIPE PRIMARY KEY (refproj,refemp),
    FOREIGN KEY (refproj) REFERENCES PROJET(refproj),
    FOREIGN KEY (refemp) REFERENCES EMPLOYES(refemp)
);
CREATE TABLE TACHE (
    refproj INT,
    refemp INT,
    semaine INT,
    nbheures INT,
    CONSTRAINT P_TACHE PRIMARY KEY (refproj,refemp,semaine),
    FOREIGN KEY (refproj) REFERENCES PROJET(refproj),
    FOREIGN KEY (refemp) REFERENCES EMPLOYES(refemp)
);

-- 1. Transformer en majuscule la valeur du l'attribut nom des employés dans la table EMPLOYES.
CREATE OR REPLACE TRIGGER Question1
BEFORE INSERT OR UPDATE ON EMPLOYES
FOR EACH ROW
BEGIN
    :new.nom := UPPER(:new.nom);
END;
/

INSERT INTO EMPLOYES (refemp, nom, prenom, salTot, NbProjet) VALUES (1, 'Tadjer', 'Badr', 3000, 2);
INSERT INTO EMPLOYES (refemp, nom, prenom, salTot, NbProjet) VALUES (2, 'TRAn', 'Leo', 1000, 4);
INSERT INTO EMPLOYES (refemp, nom, prenom, salTot, NbProjet) VALUES (3, 'EL BANNA', 'Maha', 2000, 6);
INSERT INTO EMPLOYES (refemp, nom, prenom, salTot, NbProjet) VALUES (4, 'ChAlOnS', 'Guillaume', 500, 1);

SELECT * FROM EMPLOYES;

-- 2. Mettre à jour automatiquement la clé primaire refemp de la table EMPLOYES.
CREATE OR REPLACE TRIGGER Question2 
BEFORE INSERT ON EMPLOYES
FOR EACH ROW
BEGIN
    SELECT MAX(refemp) + 1 into :new.refemp FROM EMPLOYES;
END;
/

INSERT INTO EMPLOYES (refemp, nom, prenom, salTot, NbProjet) VALUES (7, 'MAVOuLANA', 'Moubina', 200, 1);

SELECT * FROM EMPLOYES;

-- 3. Mettre à jour l'attribut salTot d'un employé de la table EMPLOYES (cas d'insertion seulement).
CREATE OR REPLACE TRIGGER Question3
AFTER INSERT ON TACHE
FOR EACH ROW
BEGIN
    UPDATE EMPLOYES SET salTot = salTot + (:NEW.nbheures * 100) 
    WHERE refemp = :NEW.refemp;
END;
/

INSERT INTO PROJET (refproj, refemp, nomp, nbheuresprevues, nbheureseffectuees, budget) VALUES (1, 1, 'Projet 1', 120, 90, 120000);
INSERT INTO PROJET (refproj, refemp, nomp, nbheuresprevues, nbheureseffectuees, budget) VALUES (2, 2, 'Projet 2', 90, 10, 120000);
INSERT INTO PROJET (refproj, refemp, nomp, nbheuresprevues, nbheureseffectuees, budget) VALUES (3, 3, 'Projet 3', 13, 1, 120000);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (1, 1, 1, 5);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (2, 2, 1, 1);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (3, 3, 1, 8);

SELECT * FROM TACHE;
SELECT * FROM EMPLOYES;
SELECT * FROM PROJET;

-- 4. Mettre à jour l'attribut nbheureseffectuees de la table PROJET.
CREATE OR REPLACE TRIGGER Question4
AFTER INSERT OR UPDATE ON TACHE
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        UPDATE PROJET SET nbheureseffectuees = nbheureseffectuees + :NEW.nbheures 
        WHERE refproj = :NEW.refproj;
    END IF;
    IF UPDATING THEN
        UPDATE PROJET SET nbheureseffectuees = nbheureseffectuees + :NEW.nbheures - :OLD.nbheures 
        WHERE refproj = :NEW.refproj;
    END IF;
END;
/

INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (1, 1, 2, 5);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (2, 2, 2, 1);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (3, 3, 2, 8);

SELECT * FROM PROJET;

-- 5. Mettre à jour automatiquement l'attribut NbProjet de la table EMPLOYES.
CREATE OR REPLACE TRIGGER Question5
AFTER INSERT OR DELETE OF refemp ON PARTICIPE
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        UPDATE EMPLOYES SET NbProjet = NbProjet + 1
        WHERE refemp = :NEW.refemp;
    END IF;
    IF DELETING THEN
        UPDATE EMPLOYES SET NbProjet = NbProjet - 1
        WHERE refemp = :OLD.refemp;
    END IF;
END;
/


SELECT * FROM EMPLOYES;

INSERT INTO PROJET (refproj, refemp, nomp, nbheuresprevues, nbheureseffectuees, budget) VALUES (4, 1, 'Projet 4', 213, 13, 120000);
INSERT INTO PROJET (refproj, refemp, nomp, nbheuresprevues, nbheureseffectuees, budget) VALUES (5, 1, 'Projet 5', 213, 13, 120000);
UPDATE PROJET SET refemp = 1 WHERE refproj = 3;
DELETE FROM PROJET WHERE refproj = 5;

SELECT * FROM EMPLOYES;

-- 6. L’attribut refemp représente le directeur d’un projet. Interdire le directeur d’un projet d’effectuer des tâches sur son propre projet.
-- Nb : Utiliser la requête suivante pour la gestion d’erreur
-- raise_application_error(- 20300, ’message ’);
CREATE OR REPLACE TRIGGER Question6
AFTER INSERT OR UPDATE ON TACHE
FOR EACH ROW
DECLARE
    dirProj VARCHAR(100);
BEGIN
    SELECT refemp INTO dirProj 
    FROM PROJET 
    WHERE refproj = :NEW.refproj;

    IF dirProj = :NEW.refemp THEN
        raise_application_error(-20001, 'impossible de assigner une tache au directeur du projet');
    END IF;
END;
/

INSERT INTO PROJET (refproj, refemp, nomp, nbheuresprevues, nbheureseffectuees, budget) VALUES (6, 4, 'Projet 6', 213, 13, 120000);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (6, 1, 2, 5);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (6, 4, 2, 5);

-- 7. Il faut veiller sur la vérification de nombre d’heures effectuées, qui ne doit pas dépasser le nombre d’heures prévues pour la réalisation d’un projet.
-- En cas de dépassement, il faut écrire un message dans la table TAB LOG prévue pour recueillir les anomalies constatées lors de la gestion des projets.
-- Le schéma de la table TAB LOG est TAB LOG(NumPb, date pb, refproj, message). Le champ NumPb est un champ qui doit se remplir et s’incrémenter automatiquement.
CREATE SEQUENCE tab_log_seq START WITH 1;

CREATE TABLE TAB_LOG(
    NumPb INT PRIMARY KEY NOT NULL,
    datepb DATE,
    refproj INT,
    message VARCHAR(1000),
    FOREIGN KEY (refproj) REFERENCES PROJET(refproj)
);

CREATE OR REPLACE TRIGGER T_tab_log_seq
BEFORE INSERT ON TAB_LOG
FOR EACH ROW
BEGIN
    SELECT tab_log_seq.NEXTVAL INTO :NEW.NumPb FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER Question7
AFTER INSERT OR UPDATE ON PROJET
FOR EACH ROW
BEGIN
    IF :NEW.nbheuresprevues < :NEW.nbheureseffectuees THEN
        INSERT INTO TAB_LOG (datepb, refproj, message) VALUES (SYSDATE, :NEW.refproj, 'probleme de date');
    END IF;
END;
/

SELECT * FROM TAB_LOG;
SELECT * FROM PROJET;

INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (1, 5, 10, 26);
INSERT INTO TACHE (refproj, refemp, semaine, nbheures) VALUES (3, 5, 11, 1);

SELECT * FROM TAB_LOG;
SELECT * FROM PROJET;

-- 8. La modification au niveau de la table TAB LOG est interdite, en cas de modification de celle-ci, on veut connaitre celui qui l’a modifié (l’utilisateur courant USER) ainsi que la date de cette modification.
-- Ces informations seront automatiquement insérées dans la table AuditTable LOG(Num Pb, Modifie par, Date Modif).

CREATE SEQUENCE log_seq START WITH 1;

CREATE TABLE LOG(
    NumPb INT PRIMARY KEY NOT NULL, 
    ModifiedBy VARCHAR2(30),
    ModifiedAt DATE 
);

CREATE OR REPLACE TRIGGER T_log_seq
BEFORE INSERT ON LOG
FOR EACH ROW
BEGIN
    SELECT log_seq.NEXTVAL INTO :NEW.NumPb FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER Question8
BEFORE UPDATE OR DELETE ON TAB_LOG
BEGIN
    INSERT INTO LOG (ModifiedBy, ModifiedAt) VALUES (USER, SYSDATE);
END;
/

SELECT * FROM LOG;

DELETE FROM TAB_LOG WHERE NumPb = 1;

SELECT * FROM LOG;