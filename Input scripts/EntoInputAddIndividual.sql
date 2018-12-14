USE Rapento
GO

EXEC AddIndividual @GivenGenusName = 'Lagria',
				@GivenSpeciesName = 'hirta',
				@GivenDeterminedBy = 'Rik Wouters',
				@GivenDeterminationDate = '2018-04-22',
				@GivenYcoor = 52.436343,
				@GivenXcoor = 4.534554,
				@GivenLocalityName = 'Berg',
				@GivenSamplingDate = '2018-04-15',
				@GivenCollectionName = 'Test'
GO