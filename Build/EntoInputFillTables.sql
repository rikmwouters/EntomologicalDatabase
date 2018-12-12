USE EntoBase
GO

-------------------Specimens-------------------------------------

EXEC AddSpecimen @GivenGenusName = 'Lagria',
				@GivenSpeciesName = 'hirta',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-04-22',
				@GivenYcoor = 52.436343,
				@GivenXcoor = 4.534554,
				@GivenLocalityName = 'Berg',
				@GivenCollectionDate = '2018-04-15'
GO

EXEC AddSpecimen @GivenGenusName = 'Coccinella',
				@GivenSpeciesName = 'septapunctata',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-04-22',
				@GivenYcoor = 52.436343,
				@GivenXcoor = 4.534554,
				@GivenLocalityName = 'Berg',
				@GivenCollectionDate = '2018-04-15'
GO

EXEC AddSpecimen @GivenGenusName = 'Lagria',
				@GivenSpeciesName = 'hirta',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-04-25',
				@GivenYcoor = 52.437685,
				@GivenXcoor = 4.539898,
				@GivenLocalityName = 'Rivier',
				@GivenCollectionDate = '2018-04-18'
GO

EXEC AddSpecimen @GivenGenusName = 'Vespula',
				@GivenSpeciesName = 'vulgaris',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-05-27',
				@GivenYcoor = 52.56578,
				@GivenXcoor = 4.539909,
				@GivenLocalityName = 'Stad',
				@GivenCollectionDate = '2018-04-18'
GO

EXEC AddSpecimen @GivenGenusName = 'Lagria',
				@GivenSpeciesName = 'atripes',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-05-17',
				@GivenYcoor = 52.437685,
				@GivenXcoor = 4.539898,
				@GivenLocalityName = 'Rivier',
				@GivenCollectionDate = '2018-04-18'
GO


EXEC AddSpecimen @GivenGenusName = 'Amara',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-05-17',
				@GivenYcoor = 52.587654,
				@GivenXcoor = 4.609709,
				@GivenLocalityName = 'Bos',
				@GivenCollectionDate = '2018-04-19'
GO

EXEC AddSpecimen @GivenGenusName = 'Blabs',
				@GivenIdentifiedBy = 'Rik Wouters',
				@GivenIdentificationDate = '2018-05-17',
				@GivenYcoor = 52.587654,
				@GivenXcoor = 4.609709,
				@GivenLocalityName = 'Bos',
				@GivenCollectionDate = '2018-04-19'
GO

-------------------Identifications-------------------------------------

EXEC AddIdentification @GivenSpecimenID = 3,
						@GivenGenusName = 'Lagria',
						@GivenSpeciesName = 'atripes',
						@GivenIdentifiedBy = 'Rik Wouters',
						@GivenIdentificationDate = '2018-06-23'
GO

-------------------Taxons-------------------------------------

EXEC AddTaxon @TaxonName = 'Coleoptera',
				@TaxonRank = 'Order',
				@ParentTaxonID = 0

EXEC AddTaxon @TaxonName = 'Vespulidae',
				@TaxonRank = 'Family',
				@ParentTaxonID = 0

EXEC AddTaxon @TaxonName = 'Hymenoptera',
				@TaxonRank = 'Order',
				@ParentTaxonID = 0

EXEC AddTaxon @TaxonName = 'Coccinellidae',
				@TaxonRank = 'Family',
				@ParentTaxonID = 0

EXEC AddTaxon @TaxonName = 'Carabidae',
				@TaxonRank = 'Family',
				@ParentTaxonID = 0

GO

-------------------Modify parent taxons-------------------------------------

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Vespula',
		@ParentTaxonName = 'Vespulidae'

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Vespulidae',
		@ParentTaxonName = 'Hymenoptera'

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Coccinella',
		@ParentTaxonName = 'Coccinellidae'

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Coccinellidae',
		@ParentTaxonName = 'Coleoptera'

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Blabs',
		@ParentTaxonName = 'Coleoptera'

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Amara',
		@ParentTaxonName = 'Carabidae'

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Carabidae',
		@ParentTaxonName = 'Coleoptera'

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Lagria',
		@ParentTaxonName = 'Coleoptera'

----------------------Add images-----------------------------------------------

INSERT INTO Images(SpecimenID, FileName, ImageFile)
   SELECT 1, 'hirta.jpg' AS FileName,
      * FROM OPENROWSET(BULK N'C:\Users\rikwouters\Pictures\EntoBase pictures\hirta.jpg', SINGLE_BLOB) AS ImageFile

	  INSERT INTO Images(SpecimenID, FileName, ImageFile)
   SELECT 2, 'cocci.jpg' AS FileName,
      * FROM OPENROWSET(BULK N'C:\Users\rikwouters\Pictures\EntoBase pictures\cocci.jpg', SINGLE_BLOB) AS ImageFile

	  INSERT INTO Images(SpecimenID, FileName, ImageFile)
   SELECT 3, 'atripes.jpg' AS FileName,
      * FROM OPENROWSET(BULK N'C:\Users\rikwouters\Pictures\EntoBase pictures\atripes.jpg', SINGLE_BLOB) AS ImageFile

	  INSERT INTO Images(SpecimenID, FileName, ImageFile)
   SELECT 4, 'vespula.jpg' AS FileName,
      * FROM OPENROWSET(BULK N'C:\Users\rikwouters\Pictures\EntoBase pictures\vespula.jpg', SINGLE_BLOB) AS ImageFile

	  INSERT INTO Images(SpecimenID, FileName, ImageFile)
   SELECT 6, 'amara.jpg' AS FileName,
      * FROM OPENROWSET(BULK N'C:\Users\rikwouters\Pictures\EntoBase pictures\amara.jpg', SINGLE_BLOB) AS ImageFile

	  INSERT INTO Images(SpecimenID, FileName, ImageFile)
   SELECT 4, 'blabs.jpg' AS FileName,
      * FROM OPENROWSET(BULK N'C:\Users\rikwouters\Pictures\EntoBase pictures\blabs.jpg', SINGLE_BLOB) AS ImageFile