USE Rapento
GO

DELETE FROM ExpectedTypes
DELETE FROM ExpectedStages
DELETE FROM ColRelations
DELETE FROM Specimens
DELETE FROM Collections
DELETE FROM Determinations
DELETE FROM TaxonRelations
DELETE FROM Taxons
WHERE NOT TaxonID = 0
DELETE FROM ImageRelations
DELETE FROM Images
DELETE FROM Individuals
DELETE FROM Samples
