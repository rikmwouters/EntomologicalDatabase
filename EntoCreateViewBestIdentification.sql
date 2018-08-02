Use EntoBase
GO

CREATE VIEW BestIdentifications
AS
SELECT DISTINCT SpecimenID, IdentificationID, MAX(IdentificationDate) AS IdentificationDate
	FROM (SELECT IdentificationID, SpecimenID, IdentificationDate, Inferior 
			FROM Identifications 
			WHERE Identifications.Inferior = 0)s
	GROUP BY SpecimenID, IdentificationID