---------------------
-- TP1 CORRECTION  --
---------------------

---------------------------
-- DROP TABLES and VIEWS --
---------------------------
DROP TABLE Voyage CASCADE CONSTRAINTS;
DROP TABLE Voyageur CASCADE CONSTRAINTS;
DROP TABLE Sortie CASCADE CONSTRAINTS;
DROP VIEW VOYAGEURS_MOINS50ANS;
DROP VIEW VOYAGEURS_MOINS50ANS_ROUEN;

-------------------
-- CREATE TABLES --
-------------------
CREATE TABLE Voyage(idVoyage INT UNIQUE, nomVoyage VARCHAR(255), region VARCHAR(255), distance REAL, suiteVoyage INT);
CREATE TABLE Voyageur(idVoyageur INT UNIQUE, nomVoyageur VARCHAR(255), ville VARCHAR(255), age INT);
CREATE TABLE Sortie(idVoyage INT REFERENCES Voyage(idVoyage), idVoyageur INT REFERENCES Voyageur(idVoyageur), dateSortie DATE, dureeSortie REAL, UNIQUE (idVoyage, idVoyageur, dateSortie));

-------------------
-- INSERT VOYAGE --
-------------------
INSERT INTO Voyage VALUES (1, 'Discover Honfleurs', 'Normandie', 35, NULL);
INSERT INTO Voyage VALUES (2, 'La Chemin vers Paris', 'Ile de France', 25 , NULL);
INSERT INTO Voyage VALUES (3, 'Enjoy Paris', 'Ile de France', 31, 2);
INSERT INTO Voyage VALUES (4, 'Chateau de Versailles', 'Ile de France', 18, 3);
INSERT INTO Voyage VALUES (5, 'Patrimoine historique de lOccitane', 'Occitanie', 19, NULL);
INSERT INTO Voyage VALUES (6, 'Tapis rouge cannes', 'Provence Alpes Côte dAzur', 8, 8);
INSERT INTO Voyage VALUES (7, 'Le Grand Tour du Massif', 'Normandie', 10, NULL);
INSERT INTO Voyage VALUES (8, 'Le Chemin du Saint-Nazaire', 'Hauts de France', 14.18, NULL);
INSERT INTO Voyage VALUES (9, 'Etretat', 'Normandie', 6.23, 11);
INSERT INTO Voyage VALUES (10, 'Les montagnes en Corse', 'Corse', 14.5, NULL);
INSERT INTO Voyage VALUES (11, 'Couloir du Normandie', 'Normandie', 21, NULL);
INSERT INTO Voyage VALUES (12, 'La magnifique Saint-Malo', 'Bretagne', 10.8, NULL);

---------------------
-- INSERT VOYAGEUR --
---------------------
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

-------------------
-- INSERT SORTIE --
-------------------
INSERT INTO Sortie VALUES (1, 1, '21/JUL/2011', 6);
INSERT INTO Sortie VALUES (12, 7, '28/NOV/2011', 5.5);
INSERT INTO Sortie VALUES (2, 2, '01/JAN/2007', 6);
INSERT INTO Sortie VALUES (2, 5, '17/JUN/2012', 7.5);
INSERT INTO Sortie VALUES (8, 5, '21/JUL/2008', 6.5);
INSERT INTO Sortie VALUES (4, 5, '08/MAR/2011', 3.5);
INSERT INTO Sortie VALUES (7, 3, '19/MAY/2011', 11);
INSERT INTO Sortie VALUES (9, 2, '24/JUN/2014', 7);
INSERT INTO Sortie VALUES (10, 2, '25/JUN/2011', 8.5);
INSERT INTO Sortie VALUES (4, 8, '16/APR/2010', 6);
INSERT INTO Sortie VALUES (5, 8, '17/APR/2010', 4.5);
INSERT INTO Sortie VALUES (6, 8, '18/APR/2010', 5);
INSERT INTO Sortie VALUES (11, 8, '23/AUG/2010', 6);
INSERT INTO Sortie VALUES (11, 2, '23/JUL/2012', 7);
INSERT INTO Sortie VALUES (11, 5, '23/JUL/2012', 7);
INSERT INTO Sortie VALUES (7, 2, '27/JAN/2006', 6);
INSERT INTO Sortie VALUES (9, 9, '17/MAY/2011', 6.5);
INSERT INTO Sortie VALUES (10, 9, '10/APR/2008', 6);
INSERT INTO Sortie VALUES (10, 3, '24/FEB/2006', 2);
INSERT INTO Sortie VALUES (8, 10, '13/MAY/2012', 10.5);
INSERT INTO Sortie VALUES (5, 9, '01/SEP/2009', 3);
INSERT INTO Sortie VALUES (5, 1, '01/SEP/2009', 3);
INSERT INTO Sortie VALUES (8, 7, '14/JUN/2011', 6);
INSERT INTO Sortie VALUES (8, 7, '03/JUL/2012', 5);
INSERT INTO Sortie VALUES (8, 7, '19/MAY/2007', 5.5);

-------------------------------------------------------------------
-- Partie n°1 : Exprimez les requetes suivantes en langage SQL : --
-------------------------------------------------------------------
-- 1. Toutes les informations sur les voyageurs.
SELECT * FROM Voyageur;

-- 2. Les voyageurs âgés entre 40 et 50 ans.
SELECT * FROM Voyageur WHERE age BETWEEN 40 AND 50;

-- 3. Les voyageurs de moins de 45 ans et leurs éventuelles sorties.
SELECT * FROM Voyageur v LEFT JOIN Sortie s ON v.idVoyageur = s.idVoyageur WHERE v.age < 45;

-- 4. Les voyageurs qui n’ont jamais fait de sorties (avec sous-requête).
SELECT * FROM Voyageur v WHERE v.idVoyageur NOT IN (SELECT s.idVoyageur FROM Sortie s);

-- 5. Les voyageurs qui vivent dans une ville contenant ’en’ et qui font des voyages (avec sous--requetes).
SELECT * FROM Voyageur v WHERE v.idVoyageur IN (SELECT s.idVoyageur FROM Sortie s) AND v.ville LIKE '%en%';

-- 6. Les voyageurs qui ont fait des sorties en 2011 et 2012.
SELECT * FROM Voyageur v WHERE v.idVoyageur IN (SELECT s.idVoyageur FROM Sortie s WHERE dateSortie BETWEEN '01-JAN-2011' AND '31-DEC-11') AND v.idVoyageur IN (SELECT s.idVoyageur FROM Sortie s WHERE dateSortie BETWEEN '01-JAN-2012' AND '31-DEC-12');

-- 7. Les voyageurs qui ont fait des sorties en 2011 ou 2012.
SELECT * FROM Voyageur v INNER JOIN Sortie s ON v.idVoyageur = s.idVoyageur WHERE dateSortie BETWEEN '01-JAN-2011' AND '31-DEC-12';

-- 8. Le voyageur le plus âgé (avec sous-requête).
SELECT * FROM Voyageur WHERE age = (SELECT MAX(age) FROM Voyageur);

-- 9. Le nombre total des voyageurs.
SELECT COUNT(*) AS nbVoyageur FROM Voyageur;

-- 10. L’âge moyen des voyageurs.
SELECT AVG(AGE) AS AVGage FROM Voyageur;

-- 11. L’identifiant et le nom des voyages de plus de 20 kms.
SELECT idVoyage, nomVoyage FROM Voyage WHERE distance > 20;

-- 12. Les voyages qui ont une suite.
SELECT * FROM Voyage WHERE suiteVoyage IS NOT NULL;

-- 13. Les informations sur les voyages ainsi que sur le voyage qui suit.
SELECT v1.*, v2.* FROM Voyage v1 INNER JOIN Voyage v2 ON v1.suiteVoyage = v2.idVoyage;

-- 14. Le voyage qui n’a jamais été fait par un voyageur (avec sous-requête).
SELECT * FROM Voyage WHERE idVoyage NOT IN (SELECT idVoyage FROM Sortie);

-- 15. La sortie la plus longue (avec sous-requête).
SELECT * FROM Sortie WHERE dureeSortie = (SELECT MAX(dureeSortie) FROM Sortie);

-- 16. La distance maximale des voyages.
SELECT MAX(distance) AS distanceMax FROM Voyage;

-- 17. Le nombre de voyage de la région de Provence Alpes Côte d'Azur. 
SELECT COUNT(*) AS nbVoyagePaca FROM Voyage WHERE region LIKE 'Provence Alpes Côte dAzur';

-- 18. Le nombre de voyages effectuées par voyageur.
SELECT idVoyageur, COUNT(*) as Total FROM Sortie GROUP BY idVoyageur;

-- 19. Le nombre de voyage effectuées par région.
SELECT region , COUNT(*) AS Total FROM Voyage GROUP BY region;

-- 20. La sortie la plus récente.
SELECT * FROM Sortie WHERE dateSortie = (SELECT MAX(dateSortie) FROM Sortie);

-- 21. Le nombre de sorties effectuées par jour.
SELECT dateSortie, COUNT(*) AS Total FROM Sortie GROUP BY dateSortie ORDER BY dateSortie;

-- 22. Le nombre de sorties effectuées par an.
SELECT EXTRACT(YEAR FROM DATESORTIE) AS annee, COUNT(*) AS total FROM Sortie GROUP BY EXTRACT(YEAR FROM dateSortie) ORDER BY EXTRACT(YEAR FROM dateSortie);

---------------------------------------------------------
-- Partie n°2 : Effectuez les mises à jour suivantes : --
---------------------------------------------------------
-- 1. Mettre à jour la ville de naissance du voyageur Nicolas par Paris.
UPDATE VOYAGEUR SET VILLE = 'Paris' WHERE NOMVOYAGEUR LIKE 'Nicolas';

-- 2. Mettre en majuscule tous les noms des voyageurs.
UPDATE VOYAGEUR SET NOMVOYAGEUR = UPPER(NOMVOYAGEUR);

-- 3. Mettre à jour les voyages qui n’ont pas de suite par la valeur 0.
UPDATE VOYAGE SET SUITEVOYAGE = 0 WHERE SUITEVOYAGE IS NULL;

-- 4. Ajouter un nouveau attribut ’pays’ à la table voyage et mettre à jour la colonne par la valeur France.
ALTER TABLE Voyage ADD pays VARCHAR(255);
UPDATE VOYAGE SET PAYS = 'France';

-- 5. Ajouter deux contraintes d’intégrité permettant de garantir que la distance des voyages ainsi que l’âge des voyageurs soient strictement positives.
ALTER TABLE VOYAGE ADD CONSTRAINT POSITIVE_DISTANCE CHECK (DISTANCE > 0);
ALTER TABLE VOYAGEUR ADD CONSTRAINT POSITIVE_AGE CHECK (AGE > 0);

--------------------------------------
-- Partie n°3 : Création des vues : --
--------------------------------------
-- 1. Créer une vue contenant les voyageurs de moins de 50 ans.
CREATE VIEW VOYAGEURS_MOINS50ANS AS SELECT * FROM VOYAGEUR WHERE AGE < 50;
SELECT * FROM VOYAGEURS_MOINS50ANS;

-- 2. Créer une vue contenant les noms des voyageurs de moins de 50 qui ont fait un voyage à Rouen (utiliser la vue précédemment crée).
CREATE VIEW VOYAGEURS_MOINS50ANS_ROUEN AS SELECT * FROM VOYAGEURS_MOINS50ANS WHERE VILLE LIKE 'Rouen';
SELECT * FROM VOYAGEURS_MOINS50ANS_ROUEN;