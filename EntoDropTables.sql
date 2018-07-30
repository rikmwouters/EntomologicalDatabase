USE [EntoBase]
GO

BEGIN TRAN

BEGIN TRY
	DROP TABLE dbo.Specimens, dbo.Collections, dbo.Identifications, dbo.HostRelations, dbo.PrimaryTaxons, dbo.HostTaxons
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


