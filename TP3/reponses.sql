-- Questions test :
-- 1. Écrire en langage PL/SQL la fonction factoriel(n) qui calcule la factoriel d’un nombre et le
-- programme permettant d’afficher le factoriel(15)

CREATE OR REPLACE FUNCTION factoritel(n NUMBER) RETURN NUMBER IS
    f NUMBER;
BEGIN
    f:=1;
    FOR i IN 1..n LOOP
      f:=f*i;
    END LOOP;
    RETURN f;
END;
/

-- 2. En utilisant la fonction déjà définie précédemment, calculer la factorielle d’une valeur donnée en
-- entrée par l’utilisateur

DECLARE    
    resultat number(8);    
BEGIN 
    resultat := factoritel(3);    
    dbms_output.put_line(resultat);    
END;    
/

-- Questions sur le script de Tp n°1 :
DROP TABLE Sortie;
DROP TABLE Voyage;
DROP TABLE Voyageur;

-- Jeu de données sur des voyages  

-- Creation des trois tables 

CREATE TABLE Voyage(idVoyage INT UNIQUE, nomVoyage VARCHAR(255), region VARCHAR(255), distance REAL, suiteVoyage INT);
CREATE TABLE Voyageur(idVoyageur INT UNIQUE, nomVoyageur VARCHAR(255), ville VARCHAR(255), age INT);
CREATE TABLE Sortie(idVoyage INT REFERENCES Voyage(idVoyage), idVoyageur INT REFERENCES Voyageur(idVoyageur), dateSortie DATE, dureeSortie REAL, UNIQUE (idVoyage, idVoyageur, dateSortie));

-- Insertions de tuples dans les tables
INSERT INTO Voyage VALUES (1, 'Discover Honfleurs', 'Normandie', 35, NULL);
INSERT INTO Voyage VALUES (2, 'La Chemin vers Paris', 'Ile de France', 25 , NULL);
INSERT INTO Voyage VALUES (3, 'Enjoy Paris', 'Ile de France', 31, 2);
INSERT INTO Voyage VALUES (4, 'Chateau de Versailles', 'Ile de France', 18, 3);
INSERT INTO Voyage VALUES (5, 'Patrimoine historique de l Occitane', 'Occitanie', 19, NULL);
INSERT INTO Voyage VALUES (6, 'Tapis rouge cannes', 'Provence Alpes Côte d Azur', 8, 8);
INSERT INTO Voyage VALUES (7, 'Le Grand Tour du Massif', 'Normandie', 10, NULL);
INSERT INTO Voyage VALUES (8, 'Le Chemin du Saint-Nazaire', 'Hauts de France', 14.18, NULL);
INSERT INTO Voyage VALUES (9, 'Etretat', 'Normandie', 6.23, 11);
INSERT INTO Voyage VALUES (10, 'Les montagnes en Corse', 'Corse', 14.5, NULL);
INSERT INTO Voyage VALUES (11, 'Couloir du Normandie', 'Normandie', 21, NULL);
INSERT INTO Voyage VALUES (12, 'La magnifique Saint-Malo', 'Bretagne', 10.8, NULL);
-----------------------------------------------------------------------------------------------------
INSERT INTO Voyageur VALUES (1, 'Nolwen', 'Montpellier', 18);
INSERT INTO Voyageur VALUES (2, 'Eva', 'Paris', 22);
INSERT INTO Voyageur VALUES (3, 'Janson', 'Paris', 34);
INSERT INTO Voyageur VALUES (4, 'Brouna', 'Lille', 45);
INSERT INTO Voyageur VALUES (5, 'Nelson', 'Marseille', 59);
INSERT INTO Voyageur VALUES (6, 'Sofie', 'Nice', 66);
INSERT INTO Voyageur VALUES (7, 'Patrick', 'Lille', 54);
INSERT INTO Voyageur VALUES (8, 'Baptiste', 'Lille', 38);
INSERT INTO Voyageur VALUES (9, 'Nicolas', 'Rouen', 29);
INSERT INTO Voyageur VALUES (10, 'Sara', 'Rouen', 21);
-----------------------------------------------------------------------------------------------------
INSERT INTO Sortie VALUES (1, 1, '21/07/2011', 6);
INSERT INTO Sortie VALUES (12, 7, '28/11/2011', 5.5);
INSERT INTO Sortie VALUES (2, 2, '01/01/2007', 6);
INSERT INTO Sortie VALUES (2, 5, '17/06/2012', 7.5);
INSERT INTO Sortie VALUES (8, 5, '21/07/2008', 6.5);
INSERT INTO Sortie VALUES (4, 5, '08/03/2011', 3.5);
INSERT INTO Sortie VALUES (7, 3, '19/05/2011', 11);
INSERT INTO Sortie VALUES (9, 2, '24/06/2014', 7);
INSERT INTO Sortie VALUES (10, 2, '25/06/2011', 8.5);
INSERT INTO Sortie VALUES (4, 8, '16/04/2010', 6);
INSERT INTO Sortie VALUES (5, 8, '17/04/2010', 4.5);
INSERT INTO Sortie VALUES (6, 8, '18/04/2010', 5);
INSERT INTO Sortie VALUES (11, 8, '23/08/2010', 6);
INSERT INTO Sortie VALUES (11, 2, '23/07/2012', 7);
INSERT INTO Sortie VALUES (11, 5, '23/07/2012', 7);
INSERT INTO Sortie VALUES (7, 2, '27/01/2006', 6);
INSERT INTO Sortie VALUES (9, 9, '17/05/2011', 6.5);
INSERT INTO Sortie VALUES (10, 9, '10/04/2008', 6);
INSERT INTO Sortie VALUES (10, 3, '24/02/2006', 2);
INSERT INTO Sortie VALUES (8, 10, '13/05/2012', 10.5);
INSERT INTO Sortie VALUES (5, 9, '01/09/2009', 3);
INSERT INTO Sortie VALUES (5, 1, '01/09/2009', 3);
INSERT INTO Sortie VALUES (8, 7, '14/06/2011', 6);
INSERT INTO Sortie VALUES (8, 7, '03/07/2012', 5);
INSERT INTO Sortie VALUES (8, 7, '19/05/2007', 5.5);
-----------------------------------------------------------------------------------------------------

-- 3. Écrire une procédure permettant d’afficher la catégorie ainsi que le nom de chaque voyageur. La
-- catégorie est définie comme suit :
-- ? Si l’âge du voyageur est inferieur a 18 ans ---> Junior
-- ? Si l’âge du voyageur est supérieur à 50 ans ---> Senior
-- ? Pour les autres voyageurs --->Middle

CREATE OR REPLACE PROCEDURE AffichageCat(part Voyageur%ROWTYPE) AS
categorie VARCHAR2(50);
BEGIN
    IF (part.age < 18) THEN
        categorie := 'Junior';
    ELSIF (part.age > 50) THEN
        categorie := 'Senior';
    ELSE
        categorie := 'Middle';
    END IF;
    dbms_output.put_line(part.nomVoyageur || '(' || categorie || ')'); 
END;

DECLARE 
    particip Voyageur%ROWTYPE;
BEGIN
    for particip IN (SELECT * FROM Voyageur)
    LOOP
        AffichageCat(particip);
    END LOOP;
END;

-- 4. Écrire une procédure permettant d’afficher les informations d’un voyageur à partir de son
-- identifiant (idVoyageur).

CREATE OR REPLACE PROCEDURE AffichageInfVoy(idVoy Voyageur.idVoyageur%TYPE) AS 
    part Voyageur%ROWTYPE;
BEGIN
    SELECT * INTO part FROM Voyageur WHERE idVoyageur = idVoy;
    dbms_output.put_line(part.idVoyageur||' '||part.nomVoyageur||' '||part.ville||' '||part.age);
END;
   
BEGIN
    AffichageInfVoy(2);
END;

-- 5. Écrire un trigger qui se déclenche avant la suppression d’un voyageur. Le trigger devra supprimer
-- toutes les sorties de ce voyageur.
-- Faire le test avec la suppression du participant ’Nelson’.

CREATE OR REPLACE TRIGGER SupVoy BEFORE DELETE ON Voyageur
FOR EACH ROW
BEGIN 
    DELETE from Sortie WHERE idVoyageur = :OLD.idVoyageur;
END;
/

DELETE FROM Voyageur WHERE nomVoyageur = 'Nelson';

-- 6. Ajouter dans la table voyageur l’attribut catégorie.
-- ? L’attribut catégorie devra contenir la catégorie du voyageur.

ALTER TABLE Voyageur ADD categorie VARCHAR(20);

CREATE OR REPLACE PROCEDURE AffichageCat2(part Voyageur%ROWTYPE) AS
    cat VARCHAR2(50);
BEGIN
    IF (part.age < 18) THEN
        cat := 'Junior';
    ELSIF (part.age > 50) THEN
        cat := 'Senior';
    ELSE
        cat := 'Middle';
    END IF;
    UPDATE Voyageur SET categorie = cat  WHERE idVoyageur = part.idVoyageur;
END;
/

DECLARE 
    cat Voyageur%ROWTYPE;
BEGIN
    for cat IN (SELECT * FROM Voyageur)
    LOOP
        AffichageCat2(cat);
    END LOOP;
END;

Select * from Voyageur;

-- 7. Créer un trigger qui permet de s’assurer qu’à l’insertion ou à la mise à jour d’un voyage, que celui-ci ne peut être la suite de lui-même.
CREATE OR REPLACE TRIGGER DisplayError BEFORE INSERT OR UPDATE ON Voyage
FOR EACH ROW
BEGIN
    IF :new.idVoyage = :new.suiteVoyage THEN
        raise_application_error(-20300, 'une suite doit être différente d un voyage' ); 
    END IF;
END;
/

