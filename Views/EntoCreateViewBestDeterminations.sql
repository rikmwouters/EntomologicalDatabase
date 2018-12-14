Use Rapento
GO

CREATE VIEW BestDeterminations
AS
SELECT DISTINCT IndividualID, DeterminationID, MAX(DeterminationDate) AS DeterminationDate
	FROM (SELECT DeterminationID, IndividualID, DeterminationDate, Inferior 
			FROM Determinations 
			WHERE Determinations.Inferior = 0)s
	GROUP BY IndividualID, DeterminationID