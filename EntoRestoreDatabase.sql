USE EntoBase
GO

ALTER DATABASE EntoBase 
	SET SINGLE_USER 
	WITH ROLLBACK IMMEDIATE  
ALTER DATABASE EntoBase 
	SET MULTI_USER

RESTORE DATABASE EntoBase  
   FROM DISK = 'C:\Users\rikwouters\Documents\EntoBaseBackup\EntoBackup.bak'



--WERKT NIET