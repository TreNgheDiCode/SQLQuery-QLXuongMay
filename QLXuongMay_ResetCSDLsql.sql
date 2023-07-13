-- Tắt tất cả kết nối đến database
DECLARE @DatabaseName nvarchar(50)
SET @DatabaseName = N'QLXuongMay'

DECLARE @SQLDropConnection varchar(max)

SELECT @SQLDropConnection = COALESCE(@SQLDropConnection,'') + 'Kill ' + Convert(varchar, SPId) + ';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

--SELECT @SQL 
EXEC(@SQLDropConnection)

-- Tắt TẤT CẢ khóa ngoại
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- Xóa TẤT CẢ bảng
DECLARE @sql NVARCHAR(max)=''

SELECT @sql += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql