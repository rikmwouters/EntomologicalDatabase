USE Rapento
GO

BEGIN TRAN

BEGIN TRY
	DROP TABLE IF EXISTS dbo.ImageRelations, dbo.Images, dbo.Determinations, dbo.TaxonRelations, dbo.Taxons, dbo.ColRelations, dbo.Collections, dbo.Specimens, dbo.Individuals, dbo.Samples
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	SELECT  
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH

GO


