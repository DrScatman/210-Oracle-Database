-- file: t.sql
-- author: JRA
SPOOL t.out
SET ECHO ON

SELECT *
FROM Sailors s, Reservations r
WHERE s.sid = r.sid;

COMMIT;
SET ECHO OFF
SPOOL OFF