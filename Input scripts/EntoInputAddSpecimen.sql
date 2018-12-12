USE EntoBase
GO

EXEC AddSpecimen @GivenGenusName = 'Lagria',
				@GivenSpeciesName = 'hirta',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-04-22',
				@GivenYcoor = 52.436343,
				@GivenXcoor = 4.534554,
				@GivenLocalityName = 'Berg',
				@GivenCollectionDate = '2018-04-15'
GO