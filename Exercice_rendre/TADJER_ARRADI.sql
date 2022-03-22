---------
-- TP2 --
---------

TADJER BADR
ARRADI NAOUFAL

-----------------
-- DROP TABLES --
-----------------
DROP TABLE Etudiant CASCADE CONSTRAINTS;
DROP TABLE Cours CASCADE CONSTRAINTS;
DROP TABLE Inscription CASCADE CONSTRAINTS;
DROP TABLE Professeur CASCADE CONSTRAINTS;

-------------------
-- CREATE TABLES --
-------------------
CREATE TABLE Professeur(
    idProf int,
    prenom varchar2(255),
    idDep int,
    constraint P_Professeur primary key (idProf)
);

CREATE TABLE Etudiant(
    idEtud INT UNIQUE,
    nomEtud VARCHAR(255),
    age INT,
    niveau varchar2(255),
    section varchar2(255)
);

CREATE TABLE Cours(
    nomC varchar2(255),
    heure_cours timestamp,
    salle varchar2(255),
    idProf int,
    foreign key (idProf) references Professeur(idProf),
    constraint P_Cours primary key (nomC)
);

CREATE TABLE Inscription(
    idEtud int,
    nomC varchar2(255),
    foreign key (idEtud) references Etudiant(idEtud),
    foreign key (nomC) references Cours(nomC)
);

-- �crire en langage PL/SQL les d�clencheurs des requ�tes suivants :
-- 1. L�effectif maximum des �tudiants pour chaque cours est 30 �tudiants.
DROP TRIGGER Question1;
CREATE OR REPLACE TRIGGER Question1 AFTER INSERT ON Inscription 
FOR EACH ROW
DECLARE
    nbEtud NUMBER;
BEGIN
    SELECT COUNT(*) INTO nbEtud FROM Inscription WHERE nomC = :NEW.nomC;
    IF nbEtud > 30 THEN
        RAISE_APPLICATION_ERROR(-20005, 'sup�rieur � 30 etudiants');
    END IF;
END;

INSERT INTO Inscription VALUES(1, 'SQL');

-- 2. Uniquement les enseignants qui font partie de d�partement dont l'IdDep = 33 ont le droit d�enseigner plus de trois cours.
DROP TRIGGER Question2;
CREATE OR REPLACE TRIGGER Question2 AFTER INSERT OR UPDATE ON Cours
FOR EACH ROW
DECLARE
    nbCours NUMBER;
    idDepartement NUMBER;
BEGIN
    SELECT idDep INTO idDepartement FROM Professeur WHERE idProf = :NEW.idProf;
    SELECT COUNT(*) INTO nbCours FROM Cours WHERE idProf = :NEW.idProf;
    IF idDepartement != 33 AND nbCours > 3 THEN
        RAISE_APPLICATION_ERROR(-20005, 'trop de cours');
    END IF;
END;
/
    
-- 3. Chaque �tudiant doit �tre obligatoirement inscrit au cours intitul� "Data warehouse".
DROP TRIGGER Question3;
CREATE OR REPLACE TRIGGER Question3 AFTER INSERT ON Etudiant 
FOR EACH ROW
BEGIN
    INSERT INTO Inscription VALUES(:NEW.idEtud, 'Data warehouse');
END;
/

-- 4. Chaque d�partement ne doit pas avoir plus de 10 enseignants.
DROP TRIGGER Question4;
CREATE OR REPLACE TRIGGER Question4 AFTER INSERT OR UPDATE ON Professeur 
FOR EACH ROW
DECLARE
    nbProf NUMBER;
BEGIN
    SELECT COUNT(*) INTO nbProf FROM Professeur WHERE idDep = :NEW.idDep;
    IF nbProf > 10 THEN
        RAISE_APPLICATION_ERROR(-20005, 'erreur');
    END IF;
END;
/

-- 5. Le nombre d��tudiants inscrits dans le module base de donn�es r�partis doit �tre sup�rieur au nombre d��tudiants dans le module math�matique pour l'info.
DROP TRIGGER Question5;
CREATE OR REPLACE TRIGGER Question5 BEFORE INSERT ON Etudiant 
FOR EACH ROW
DECLARE
    nbBDD NUMBER;
    nbMath NUMBER;
BEGIN
    SELECT COUNT(*) INTO nbBDD FROM Etudiant WHERE niveau = 'Base de donnees';
    SELECT COUNT(*) INTO nbMath FROM Etudiant WHERE niveau = 'Math�matiques pour l info';
    IF nbMath > nbBDD THEN
        RAISE_APPLICATION_ERROR(-20005,'erreur');
    END IF;
END;
/

-- 6. Le nombre d'inscription aux modules enseign�s par les enseignants du d�partement dont l'IdDep = 33 doivent �tre sup�rieur au nombre d'inscriptions dans module Optimisation.
DROP TRIGGER Question6;
CREATE OR REPLACE TRIGGER Question6 AFTER INSERT ON Etudiant 
FOR EACH ROW
DECLARE
    nbDep31 NUMBER;
    nbOpti NUMBER;
BEGIN
    SELECT COUNT(*) INTO nbDep31 FROM Professeur P INNER JOIN Cours C ON P.idProf = C.idProf INNER JOIN Inscription I ON I.nomC = C.nomC WHERE P.idDep = 33;
    SELECT COUNT(*) INTO nbOpti FROM Etudiant WHERE niveau = 'Optimisation';
    IF nbDep31 > nbOpti THEN
        RAISE_APPLICATION_ERROR(-20005, 'erreur');
    END IF;
END;
/

-- 7. Les professeurs qui ne font pas partie de m�mes d�partements ne peuvent pas enseigner dans la m�me salle.
DROP TRIGGER Question7;
CREATE OR REPLACE TRIGGER Question7 BEFORE INSERT OR UPDATE ON Cours 
FOR EACH ROW
DECLARE
    departement NUMBER;
    nbC NUMBER;
BEGIN
    SELECT idDep INTO departement FROM Professeur WHERE idProf = :NEW.idProf;
    SELECT count(*) INTO nbC FROM Cours C INNER JOIN Professeur P ON C.idProf = P.idProf WHERE C.salle = :NEW.salle AND P.idDep != departement;
    IF departement > nbC THEN
        RAISE_APPLICATION_ERROR(-20005, 'erreur');
    END IF;
END;


