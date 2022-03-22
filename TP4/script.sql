--- Création des tables

CREATE TABLE Fournisseur (NumF char(6) primary key, NomF char(20), Statut SMALLINT, Ville CHAR(20));
CREATE TABLE Produit (NumPd char(6) primary key, NomPd char(20), Couleur char(6), Poids SMALLINT, Prix real, Ville CHAR(10));
CREATE TABLE Projet (NumPj char(6) primary key, NomPj char(50), ville CHAR(10));
CREATE TABLE Commande (NumF CHAR(6), NumPd CHAR(6),NumPj char(6), Quantite INTEGER);


--- Insertion des données
--Fournisseur
INSERT INTO Fournisseur VALUES ('F1','Antoine',20,'Paris');
INSERT INTO Fournisseur VALUES ('F2','Daniel',10,'Lyon');
INSERT INTO Fournisseur VALUES ('F3','Jimmy',30,'Lyon');
INSERT INTO Fournisseur VALUES ('F4','Nicolas',20,'Paris');
INSERT INTO Fournisseur VALUES ('F5','Didier',30,'Toulouse');

-- Produit
INSERT INTO Produit VALUES('P1','ecrou','rouge',12,30,'Paris');
INSERT INTO Produit VALUES('P2','verrou','vert',17,100,'Lyon');
INSERT INTO Produit VALUES('P3','vis','bleu',17,12,'Lille');
INSERT INTO Produit VALUES('P4','vis','rouge',14,15,'Paris');
INSERT INTO Produit VALUES('P5','clou','bleu',12,10,'Lyon');
INSERT INTO Produit VALUES('P6','rivet','rouge',20,22,'Paris');

-- Projet
INSERT INTO Projet VALUES ('J1','RECYCLAGE DE DECHETS','Lyon');
INSERT INTO Projet VALUES ('J2','PIECES ET ACCESSOIRE AUTO','Lille');
INSERT INTO Projet VALUES ('J3','UNITE DE PRODUCTION DE GPL','Toulouse');
INSERT INTO Projet VALUES ('J4','FABRICATION DE MACHINES INDUSTRIELLES','Toulouse');
INSERT INTO Projet VALUES ('J5','COMPLEXE TOURISTIQUE','Paris');
INSERT INTO Projet VALUES ('J6','FONDERIE D ALUMINIUM','Lille');
INSERT INTO Projet VALUES ('J7','RECYCLAGES DES PNEUS USAGES','Paris');

-- Commande
INSERT INTO Commande VALUES ('F1','P1','J1',200);
INSERT INTO Commande VALUES ('F1','P1','J4',700);
INSERT INTO Commande VALUES ('F2','P3','J1',400);
INSERT INTO Commande VALUES ('F2','P3','J2',200);
INSERT INTO Commande VALUES ('F2','P3','J3',200);
INSERT INTO Commande VALUES ('F2','P3','J4',500);
INSERT INTO Commande VALUES ('F2','P3','J5',600);
INSERT INTO Commande VALUES ('F2','P3','J6',400);
INSERT INTO Commande VALUES ('F2','P3','J7',800);
INSERT INTO Commande VALUES ('F2','P5','J2',100);
INSERT INTO Commande VALUES ('F3','P3','J1',200);
INSERT INTO Commande VALUES ('F3','P4','J2',500);
INSERT INTO Commande VALUES ('F4','P6','J3',300);
INSERT INTO Commande VALUES ('F4','P6','J7',300);
INSERT INTO Commande VALUES ('F5','P2','J2',200);
INSERT INTO Commande VALUES ('F5','P2','J4',100);
INSERT INTO Commande VALUES ('F5','P5','J5',500);
INSERT INTO Commande VALUES ('F5','P5','J7',100);
INSERT INTO Commande VALUES ('F5','P6','J2',200);
INSERT INTO Commande VALUES ('F5','P1','J4',1000);
INSERT INTO Commande VALUES ('F5','P3','J4',1200);
INSERT INTO Commande VALUES ('F5','P4','J4',800);
INSERT INTO Commande VALUES ('F5','P5','J4',400);
INSERT INTO Commande VALUES ('F5','P6','J4',500);