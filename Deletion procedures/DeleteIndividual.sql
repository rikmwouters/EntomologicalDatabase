USE Rapento
GO

DROP PROCEDURE IF EXISTS dbo.DeleteIndividual
GO

CREATE PROCEDURE dbo.DeleteIndividual
	@GivenIndividualID int
	
AS

DELETE FROM Individuals
WHERE IndividualID = @GivenIndividualID