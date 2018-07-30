USE EntoBase
GO

EXEC ModifyParentTaxonWithName
		@TaxonName = 'Vespula',
		@ParentTaxonName = 'Vespulidae'