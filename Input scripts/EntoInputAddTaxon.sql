USE Rapento
GO

EXEC AddTaxon @TaxonName = 'Coleoptera',
				@TaxonRank = 'Order',
				@ParentTaxonID = 0