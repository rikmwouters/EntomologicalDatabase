USE EntoBase
GO

EXEC AddIdentification @GivenSpecimenID = 112,
						@GivenGenusName = 'Lagria',
						@GivenSpeciesName = 'atripes',
						@GivenIdentifiedBy = 'Rik Wouters',
						@GivenIdentificationDate = '2018-06-23'