USE master
GO

ALTER DATABASE EntoBase 
	SET SINGLE_USER 
	WITH ROLLBACK IMMEDIATE  


RESTORE DATABASE EntoBase  
   FROM DISK = 'C:\Users\rikwouters\Documents\EntoBaseBackup\EntoBackup.bak'

ALTER DATABASE EntoBase 
	SET MULTI_USER
