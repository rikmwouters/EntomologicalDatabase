USE EntoBase
GO

DELETE FROM Specimens
DELETE FROM Collections
DELETE FROM Identifications
DELETE FROM HostRelations
DELETE FROM PrimaryTaxons
WHERE NOT TaxonID = 0
DELETE FROM HostTaxons
WHERE NOT TaxonID = 0