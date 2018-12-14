USE Rapento
GO

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