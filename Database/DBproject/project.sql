SPOOL project.out
SET ECHO ON
/*
CIS 353 - Database Design Project
Scott Nguyen
Jake Miller
Brandon Thedorff
Alen Huric
*/
DROP TABLE Account CASCADE CONSTRAINTS;
DROP TABLE GameAccount CASCADE CONSTRAINTS;
DROP TABLE Region CASCADE CONSTRAINTS;
DROP TABLE Transaction CASCADE CONSTRAINTS;
DROP TABLE FinancialHistory CASCADE CONSTRAINTS;
DROP TABLE InGameItems CASCADE CONSTRAINTS;
DROP TABLE GameType CASCADE CONSTRAINTS;
DROP TABLE InRegion CASCADE CONSTRAINTS;
--
--CREATING THE TABLES
-------------------------------------------------------------------
CREATE TABLE Account
(
userAccID	INTEGER		NOT NULL,	  
fName		CHAR(10)	NOT NULL,
lName		CHAR(15)	NOT NULL,
email		CHAR(15)	NOT NULL,
--
-- aIC1: Account IDs are unique
CONSTRAINT aIC1 PRIMARY KEY(userAccID)
);
-------------------------------------------------------------------
CREATE TABLE Region
(
regionID	CHAR(15)	NOT NULL,
rPRICE		INTEGER,
exclusives	INTEGER,
--
-- IC1: the region id is unique
CONSTRAINT IC1 PRIMARY KEY(regionID),
--rIC2: the price is greater or equal to 0 and greater than or equal to 0 exclusives 
CONSTRAINT IC2 CHECK (rPRICE >= 0 AND exclusives >= 0),
--rIC3: Every GameAccount has a Region associated with it
CONSTRAINT IC3 CHECK (regionID IN('NTSC-J', 'NTSC-U', 'PAL', 'NTSC-C'))
);
-------------------------------------------------------------------
CREATE TABLE GameAccount
(
gameAccID	INTEGER  NOT NULL,   
lvl		INTEGER,
rank		INTEGER,
status		CHAR(10),	
name		CHAR(15),
transNum		INTEGER,
transDate	DATE,
gRegionID	CHAR(15) NOT NULL,
gUserID		INTEGER,    
-- gIC1: Game account IDS are unique
CONSTRAINT gIC1 PRIMARY KEY(gameAccID),
--gIC2: Checks the level is 1 or greater
CONSTRAINT gIC2 CHECK (lvl >= 1),
--gIC3: Checks the status to be available or sold
CONSTRAINT gIC3 CHECK (status IN('available', 'sold')),
CONSTRAINT gIC4 FOREIGN KEY (gRegionID) REFERENCES Region(regionID)
	ON DELETE CASCADE,
CONSTRAINT gIC5 FOREIGN KEY (gUserID) REFERENCES Account(userAccID)
	ON DELETE CASCADE
);
-------------------------------------------------------------------
CREATE TABLE Transaction
(
confirmNum	INTEGER,
payMethod	CHAR(15),
accntDate	DATE,
accntPrice	INTEGER,
soldBy		INTEGER	NOT NULL,
purchasedBy	INTEGER	NOT NULL,
--
-- tIC1: The confirmation number is unique
CONSTRAINT tIC1 PRIMARY KEY (confirmNUM),
-- tIC2: transactions can only be completed by user accounts
CONSTRAINT tIC2 FOREIGN KEY (soldBy) REFERENCES Account(userAccID)
	ON DELETE CASCADE,
--tlC3: purchased by refers to user accounts
CONSTRAINT tlC3 FOREIGN KEY(purchasedBy) REFERENCES Account(userAccID)
	ON DELETE CASCADE
);
-------------------------------------------------------------------
CREATE TABLE FinancialHistory
(
fUserAccID	INTEGER		NOT NULL,      
year		INTEGER		NOT NULL,
sold		INTEGER,
purchased	INTEGER,
--
-- fIC1: the user account is unique
CONSTRAINT fIC1 PRIMARY KEY(fUserAccID, year),
--flC2: foreign key that user account ID references to
CONSTRAINT fIC2 FOREIGN KEY(fUserAccID) REFERENCES Account(userAccID)
	ON DELETE CASCADE
);
------------------------------------------------------------------
CREATE TABLE InGameItems
(
inGameAccID	INTEGER	NOT NULL,
ingameItems	CHAR(15),
--
--bC1 the primary keys for this table
CONSTRAINT bC1 PRIMARY KEY (inGameAccID, ingameItems),
--bC2 the game account references to game account table
CONSTRAINT bC2 FOREIGN KEY(InGameAccID) REFERENCES GameAccount(gameAccID)
	ON DELETE CASCADE
);
-------------------------------------------------------------------
CREATE TABLE GameType
(
tGameUserAccID	INTEGER,
type	CHAR(15),
--
--gtC1 the primary keys for this type
CONSTRAINT gtC1 PRIMARY KEY (tGameUserAccID, type),
--gtC2 the game account references the game account table
CONSTRAINT gtC2 FOREIGN KEY(tGameUserAccID) REFERENCES GameAccount(gameAccID)
	ON DELETE CASCADE 
);
-------------------------------------------------------------------
CREATE TABLE InRegion
(
iRegionID	CHAR(15)	NOT NULL,
iGameID		INTEGER,
--
--iiC2 the primary keys for this table
CONSTRAINT iiC1 PRIMARY KEY (iRegionID, iGameID),
--iiC3 game ID references game account
CONSTRAINT iiC3 FOREIGN KEY (iRegionID) REFERENCES Region(regionID)
	ON DELETE CASCADE,
--iiC4 user id references user account
CONSTRAINT iiC4 FOREIGN KEY(iGameID) REFERENCES GameAccount(GameAccID)
	ON DELETE CASCADE
);
-------------------------------------------------------------------
SET FEEDBACK OFF
-------------------------------------------------------------------
-- Populating the Tables
-------------------------------------------------------------------
INSERT INTO Account VALUES (1, 'Jake', 'Miller', 'nobody@mail.com');
INSERT INTO Account VALUES (2, 'Scott', 'Nguyen', 'some@mail.com');
INSERT INTO Account VALUES (3, 'Alen', 'Huric', 'every@gmail.com');
INSERT INTO Account VALUES (4, 'Brandon', 'Thedorf', 'people@mail.com');
INSERT INTO Account VALUES (5, 'Joe', 'Smith', 'blah@gmail.com');
INSERT INTO Account VALUES (6, 'Smith', 'Joe', 'bam@mail.com');
INSERT INTO Account VALUES (7, 'Bob', 'Builders', 'bobd@gmail.com');
INSERT INTO Account VALUES (8, 'Dragon', 'Ballz', 'dbzlol@mail.com');
-------------------------------------------------------------------
INSERT INTO Region VALUES ('NTSC-J', 10, 50);
INSERT INTO Region VALUES ('NTSC-U', 15, 75);
INSERT INTO Region VALUES ('PAL', 100, 25);
INSERT INTO Region VALUES ('NTSC-C', 25, 150);
-------------------------------------------------------------------
INSERT INTO GameAccount VALUES (1, 1, 1, 'available', 'Minecraft', NULL, NULL, 'PAL', 1);
INSERT INTO GameAccount VALUES (2, 10, 10, 'available', 'CSGO', NULL, NULL, 'NTSC-J', 4);
INSERT INTO GameAccount VALUES (3, 10, 1, 'available', 'WoW', NULL, NULL, 'NTSC-U', 5);
INSERT INTO GameAccount VALUES (4, 7, 10, 'sold', 'Destiny', 123, TO_DATE('10/12/13', 'MM/DD/YY'), 'NTSC-C', 2);
INSERT INTO GameAccount VALUES (5, 8, 11, 'sold', 'Fallout 76',321, TO_DATE('12/14/15', 'MM/DD/YY'), 'PAL',3);
INSERT INTO GameAccount VALUES (6, 1, 1, 'available', 'Minecraft', NULL, NULL, 'PAL', 1);
------------------------------------------------------------------
INSERT INTO Transaction VALUES (123, 'Credit Card', TO_DATE('11/12/13' , 'MM/DD/YY'), 100, 4, 2);
INSERT INTO Transaction VALUES (321, 'Credit Card', TO_DATE('12/14/15' , 'MM/DD/YY'), 150, 5, 3);
-------------------------------------------------------------------
INSERT INTO FinancialHistory VALUES (1, 1999, NULL, NULL);
INSERT INTO FinancialHistory VALUES (2, 2013, 1, 1);
INSERT INTO FinancialHistory VALUES (3, 2015, 0, 1);
INSERT INTO FinancialHistory VALUES (4, 2013, 1, 1);
INSERT INTO FinancialHistory VALUES (5, 2015, 1, 0);
INSERT INTO FinancialHistory VALUES (6, 1998, NULL, NULL);
INSERT INTO FinancialHistory VALUES (7, 1997, NULL, NULL);
INSERT INTO FinancialHistory VALUES (8, 2020, NULL, NULL);
-------------------------------------------------------------------
INSERT INTO InGameItems VALUES (1, 'Diamond');
INSERT INTO InGameItems VALUES (2, 'HyperBeast');
INSERT INTO InGameItems VALUES (3, 'Dung');
INSERT INTO InGameItems VALUES (4, 'Ice Breaker');
INSERT INTO InGameItems VALUES (5, 'Big Boy');
INSERT INTO InGameItems VALUES (1, 'Coal');
-------------------------------------------------------------------
INSERT INTO GameType VALUES (1, 'Sandbox');
INSERT INTO GameType VALUES (2, 'FPS');
INSERT INTO GameType VALUES (3, 'MMORPG');
INSERT INTO GameType VALUES (4, 'FPS');
INSERT INTO GameType VALUES (5, 'RPG');
-------------------------------------------------------------------
INSERT INTO InRegion VALUES ('NTSC-U', 1);
INSERT INTO InRegion VALUES ('NTSC-U', 2);
INSERT INTO InRegion VALUES ('NTSC-J', 1);
INSERT INTO InRegion VALUES ('PAL', 2);
INSERT INTO InRegion VALUES ('PAL', 3);
INSERT INTO InRegion VALUES ('NTSC-U', 3);
INSERT INTO InRegion VALUES ('NTSC-C', 5);
-------------------------------------------------------------------
SET FEEDBACK ON
COMMIT;
-------------------------------------------------------------------
/* Q1 -- max query */
/* Finds the maximum Level and minimum Rank from gameAccount */
SELECT MAX(lvl) "maxLevel", MIN(rank) "minRank"
FROM GameAccount;

/* Q2 --  sum query */
/* Finds the total sold and purchased game accounts */
SELECT SUM(sold) "sumSold", SUM(purchased) "sumPurchased" 
FROM FinancialHistory;

/* Q3 -- intersect query */
/* Finds user account ID’s with google emails that have a game account */
SELECT userAccID
FROM Account
WHERE email LIKE '%@gmail.com'
INTERSECT
Select a.userAccID
FROM Account a, GameAccount g
WHERE a.userAccID = g.gUserID;

/* Q4 -- self join query */
/* Finds the user account ID's that made atleast one sale in the same year */
SELECT f1.fUserAccID, f2.fUserAccID
FROM FinancialHistory f1, FinancialHistory f2
WHERE f1.sold > 0 AND
	f1.year = f2.year AND
	f1.fUserAccID < f2.fUserAccID;
 
/* Q5 -- relational division query */
/*Finds every game account in the region PAL and returns the user account ID and their first name */
SELECT g.gameAccID
FROM GameAccount g
WHERE NOT EXISTS ((SELECT r.iRegionID
				FROM InRegion r
				WHERE r.iRegionID = 'PAL')
			MINUS
			(SELECT r1.iRegionID
			FROM InRegion r1
			WHERE  g.gRegionID = r1.iRegionID AND
			r1.iRegionID = 'PAL'))
ORDER BY g.gameAccID;

/* Q6 -- non-correlated query */
/* Finds game accounts who have a level higher than 1 and game accounts with financial history greater than 2013*/
SELECT gameAccID
FROM GameAccount
WHERE lvl > 1 AND
	gUserID IN (SELECT fUserAccID
				FROM FinancialHistory
				WHERE year > 2013);

/* Q7 -- TOP-N query */
/* Finds the top 3 region prices */
SELECT rPrice
FROM (SELECT rPrice
	FROM Region
	ORDER BY rPrice DESC)
WHERE ROWNUM <=3;

/* Q8 -- joining 4 tables query */
/* Finds every game account in a region that has been sold and who purchased it */
SELECT g.gameAccID, r.regionID, g.status, a.fName
FROM Account a, Region r, GameAccount g, Transaction t
WHERE a.userAccID = g.gUserID AND
	g.gRegionID = r.regionID AND
	g.transNum = t.confirmNum AND
	t.purchasedBy = a.userAccID AND
	g.status = 'sold'
ORDER BY a.fName;

/* Q9 -- correlated query */
/* Finds the game account ID’s with FPS game type*/
SELECT g.tGameUserAccID
FROM GameType g
WHERE g.type IN (SELECT type
		FROM GameType t
		WHERE t.type = 'FPS')
ORDER BY tGameUserAccID;

/* Q10 -- outer join query */
/* Find the ID, first name, and last name for Account holder. Also show gUserAccID for those who have them */
SELECT a.UserAccID, a.fName, a.Lname
FROM Account A LEFT OUTER JOIN GameAccount g ON a.UserAccID = g.gUserID;

/* Q11 -- GROUP BY, HAVING, and ORDER BY query */
/* Finds the total ingame items each game account has */
SELECT a.userAccID, x.ingameItems, COUNT(x.inGameAccID) "Total"
FROM Account a, GameAccount g, InGameItems x
WHERE a.userAccID = g.gUserID AND
	g.gameAccID = x.inGameAccID
GROUP BY a.userAccID, x.ingameItems
HAVING COUNT(x.ingameAccID) > 0
ORDER BY a.userAccID;

/* Q12 -- rank query */
/* Finds the rank of the account(s) that sold for $100  */
SELECT RANK(100) WITHIN GROUP
	(ORDER BY t.accntPrice) "RANK OF 100"
FROM Transaction t;
-------------------------------------------------------------------
/* Testing: aIC1 */
INSERT INTO Account VALUES (1, 'Jake', 'Miller', 'nobody@mail.com');

/* Testing: gtC2 */
INSERT INTO GameType VALUES (8, 'Sandbox');

/* Testing: gIC2 */
UPDATE GameAccount SET lvl = 0;

/* Testing: IC2 */
UPDATE Region SET rPrice = -1;
UPDATE Region SET exclusives = -1;

COMMIT;
-------------------------------------------------------------------
SPOOL OFF





