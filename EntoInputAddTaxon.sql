USE EntoBase
GO

EXEC AddTaxon @TaxonName = 'Coleoptera',
				@TaxonRank = 'Order',
				@ParentTaxonID = 0

EXEC AddTaxon @TaxonName = 'Vespulidae',
				@TaxonRank = 'Family',
				@ParentTaxonID = 0