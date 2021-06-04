USE [Inform]
GO
/****** Object:  StoredProcedure [dbo].[CreateStruct]    Script Date: 03.06.2021 17:29:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CreateStruct]
			@TCode int,
			@Tff1 nvarchar(255) = 'Excel 12.0;Database=',
			@Tff2 nvarchar(255) = ';HDR=YES',
			@XlsV nvarchar(255) = 'Microsoft.ACE.OLEDB.12.0',
			@Range nvarchar(255) = 'SELECT * FROM [Лист1$A5:BN]',
			@RangeDN nvarchar(255) = 'SELECT * FROM [Регистр$A5:BN]',
			@TfomsFile nvarchar(255),
			@MSQl nvarchar(max)= '',
			@TFN nvarchar(255)= ''
AS
BEGIN

set @TFN=@Tff1+@TfomsFile+@Tff2
			  
			  
			

set @MSQl = case when @TCode=1 then  
'
SELECT * INTO Inf_Disp
FROM OPENROWSET(''' + @XlsV +''', ''' +@TFN+''', ''' + @Range +''')

delete from Inf_Disp where [№_п/п] is null

ALTER TABLE Inf_Disp ADD [Территория] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [Телефон1] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [Телефон2] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [Телефон3] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [Мобильный] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [mail] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [По мобильному] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [по почте] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [Обзвон] NVARCHAR(255) NULL;
IF NOT EXISTS (SELECT * FROM syscolumns WHERE id = OBJECT_ID(''Inf_Disp'') AND name = ''Адрес'')
ALTER TABLE Inf_Disp ADD [Адрес] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [тел для СМС] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [Действующий полис] NVARCHAR(255) NULL;
ALTER TABLE Inf_Disp ADD [текст смс] NVARCHAR(max) NULL;
ALTER TABLE Inf_Disp ADD [текст вайбер] NVARCHAR(max) NULL;
ALTER TABLE Inf_Disp ADD [NotDublMobil] NCHAR(10) NULL;
ALTER TABLE Inf_Disp ADD [NotDublMail] NCHAR(10) NULL
'
when @TCode=2 then 
'
SELECT * INTO Inf_Prof
FROM OPENROWSET(''' + @XlsV +''', ''' +@TFN+''', ''' + @Range +''')

delete from Inf_Prof where [№_п/п] is null

ALTER TABLE Inf_Prof ADD [Территория] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [Телефон1] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [Телефон2] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [Телефон3] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [Мобильный] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [mail] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [По мобильному] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [по почте] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [Обзвон] NVARCHAR(255) NULL;
IF NOT EXISTS (SELECT * FROM syscolumns WHERE id = OBJECT_ID(''Inf_Prof'') AND name = ''Адрес'')
ALTER TABLE Inf_Prof ADD [Адрес] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [тел для СМС] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [Действующий полис] NVARCHAR(255) NULL;
ALTER TABLE Inf_Prof ADD [текст смс] NVARCHAR(max) NULL;
ALTER TABLE Inf_Prof ADD [текст вайбер] NVARCHAR(max) NULL;
ALTER TABLE Inf_Prof ADD [NotDublMobil] NCHAR(10) NULL;
ALTER TABLE Inf_Prof ADD [NotDublMail] NCHAR(10) NULL;
'
when @TCode=3 then 
'
SELECT * INTO Inf_DispNab
FROM OPENROWSET(''' + @XlsV +''', ''' +@TFN+''', ''' + @RangeDN +''')

delete from Inf_DispNab where [№_п/п] is null

ALTER TABLE Inf_DispNab ADD [Территория] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [Телефон1] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [Телефон2] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [Телефон3] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [Мобильный] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [mail] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [По мобильному] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [по почте] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [Обзвон] NVARCHAR(255) NULL;
IF NOT EXISTS (SELECT * FROM syscolumns WHERE id = OBJECT_ID(''Inf_DispNab'') AND name = ''Адрес'')
ALTER TABLE Inf_DispNab ADD [Адрес] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [тел для СМС] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [Действующий полис] NVARCHAR(255) NULL;
ALTER TABLE Inf_DispNab ADD [текст смс] NVARCHAR(max) NULL;
ALTER TABLE Inf_DispNab ADD [текст вайбер] NVARCHAR(max) NULL;
ALTER TABLE Inf_DispNab ADD [NotDublMobil] NCHAR(10) NULL;
ALTER TABLE Inf_DispNab ADD [NotDublMail] NCHAR(10) NULL;
'
end

exec sp_executesql @MSQl,N'' 

END
