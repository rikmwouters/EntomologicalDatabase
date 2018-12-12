USE EntoBase
GO

EXEC AddTaxon @TaxonName = 'Coleoptera',
				@TaxonRank = 'Order',
				@ParentTaxonID = 0