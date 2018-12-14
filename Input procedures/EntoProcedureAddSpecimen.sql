USE Rapento
GO

DROP PROCEDURE IF EXISTS dbo.AddSpecimen;  
GO
------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE AddSpecimen 
		@GivenIndividualID int,
		@GivenHostIndividualID int,
		@GivenPhysicalSpecimenID varchar(100)
AS 

INSERT INTO Specimens (IndividualID, HostIndividualID, PhysicalSpecimenID)
VALUES (@GivenIndividualID, @GivenHostIndividualID, @GivenPhysicalSpecimenID)

GO