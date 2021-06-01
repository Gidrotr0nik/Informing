use [Inform]
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Artem Pogosyan,
-- Create date: 17.05.2021
-- Description:	Подготовка списка Диспансеризации
-- =============================================
CREATE PROCEDURE [dbo].[DPDO_Disp]
		@mounthAt nvarchar(10),
		@mounthTo nvarchar(10),
		
		@probel nvarchar(10) = ' ',
		@e nvarchar(10) = 'е',
		@io nvarchar(10) = 'ё',
		@odin nvarchar(10) = '1',
		@nol nvarchar(10) = '0',
		@nenaid nvarchar(50) = 'не найден',
		@Sizo nvarchar(50) = 'СИЗО',
		@addr1 nvarchar(50) = 'Ростов-%Горького',
		@home1 nvarchar(50) = '129',
		@addr2 nvarchar(50) = '%Ростов-%Казачий%',
		@home2 nvarchar(10) = '22',
		@addr3 nvarchar(50) = '%Ростов-%Тоннельная%',
		@home3 nvarchar(10) = '4',
		@addr4 nvarchar(50) = '%Батайск%Горького%',
		@home4 nvarchar(10) = '356',
		@none nvarchar(10) = '',
		@obrM nvarchar(50) = 'Уважаемый ',
		@obrG nvarchar(50) = 'Уважаемая ',
		@sex nvarchar(10) = 'м',		

		@DTer nvarchar(max)= '',
		@DTels nvarchar(max)= '',
		@DMobPh3 nvarchar(max)= '',
		@DMobPh1 nvarchar(max)= '',
		@DMobPh2 nvarchar(max)= '',
		@Dmail nvarchar(max)= '',
		@DbyMob nvarchar(max)= '',
		@DbyPost nvarchar(max)= '',
		@DObz nvarchar(max)= '',
		@DAdrProz nvarchar(max)= '',
		@DAdrFact nvarchar(max)= '',
		@DTelForSms nvarchar(max)= '',
		@DActivPol nvarchar(max)= '',
		@DSIZO nvarchar(max)= '',
		@DTextSMS nvarchar(max)= '',
		@DTextViber nvarchar(max)= ''
AS
BEGIN
set @DTer = 'update zap
set zap.[Территория]=prz.name 
from Inf_Disp zap,
SvodMarsh ter,
[rgs].[dbo].[PRZ] prz
where ter.[IDPRZ]=prz.[IDPRZ] and zap.[Код МО по реестру F003]=ter.[код МО ЕР] 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DTels = 'update zap
set zap.[Телефон1]=ph.Phone1,
	zap.[Телефон2]=ph.Phone2,
	zap.[Телефон3]=ph.Phone3 
	from Inf_Disp zap 
	left outer join Pers pe 
	on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
	and zap.[Дата рождения]=pe.Birthday 
	left outer join Phones ph on pe.IDPers=ph.[IDPers] where 
	zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
	'

set @DMobPh3 = ' update zap 
set zap.[Мобильный]=ph.Phone3
	from Inf_Disp  zap 
	left outer join Pers pe 
	on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
	and zap.[Дата рождения]=pe.Birthday 
	left outer join Phones ph 
	on pe.IDPers=ph.[IDPers] 
	where ph.ValMobi3=''' + @odin + ''' 
	and ph.ValG3 is null 
	and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DMobPh1 = 'update zap 
set zap.[Мобильный]=ph.Phone1
	from Inf_Disp  zap 
	left outer join Pers pe 
	on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
	and zap.[Дата рождения]=pe.Birthday 
	left outer join Phones ph 
	on pe.IDPers=ph.[IDPers] 
	where ph.ValMobi1=''' + @odin + ''' 
	and ph.ValG1 is null 
	and zap.[Мобильный] is null 
	and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
	'
        
set @DMobPh2 = ' update zap 
set zap.[Мобильный]=ph.Phone2
from Inf_Disp  zap 
left outer join Pers pe 
on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
and zap.[Дата рождения]=pe.Birthday 
left outer join Phones ph 
on pe.IDPers=ph.[IDPers] 
where ph.ValMobi2=''' + @odin + ''' 
and ph.ValG2 is null 
and zap.[Мобильный] is null
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @Dmail = 'update zap 
set zap.[mail]=ph.mail 
from Inf_Disp  zap 
left outer join Pers pe 
on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
and zap.[Дата рождения]=pe.Birthday 
left outer join Phones ph 
on pe.IDPers=ph.[IDPers] 
where ph.ValMail=''' + @odin + ''' 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DbyMob = 'update zap 
set zap.[По мобильному]=''' + @odin + ''' 
from Inf_Disp zap 
where (YEAR(GETDATE()) - YEAR(zap.[Дата рождения])) < 65 
and (zap.[Мобильный] is not null or zap.[mail] is not null) 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DbyPost = 'update zap 
set zap.[по почте]=''' + @odin + ''' 
from Inf_Disp zap 
where (YEAR(GETDATE()) - YEAR(zap.[Дата рождения])) < 65 and
zap.[Адрес] is not null and zap.[По мобильному] is null 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DObz = 'update zap 
set zap.[Обзвон]=''' + @odin + ''' 
from Inf_Disp zap 
where (YEAR(GETDATE()) - YEAR(zap.[Дата рождения])) < 65 and
zap.[по почте] is null and zap.[По мобильному] is null 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DAdrProz = 'update zap 
set zap.[Адрес] = adr.Addr 
FROM Inf_Disp zap 
left outer join Pers pe 
on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
and zap.[Дата рождения]=birthday 
left outer join [rgs].[dbo].[Address] adr 
on pe.IDPers = adr.IDAddressOwner and adr.[IDAddressType]=35020 where 
zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DAdrFact = 'update zap 
set zap.[Адрес] = adr.Addr 
FROM Inf_Disp zap 
left outer join Pers pe 
on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
and zap.[Дата рождения]=birthday 
left outer join [rgs].[dbo].[Address] adr 
on pe.IDPers = adr.IDAddressOwner and adr.[IDAddressType]=35021 
where zap.[Адрес] is null 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DTelForSms = 'update zap 
set zap.[тел для СМС]=ter.[тел для СМС] 
from  Inf_Disp zap, 
SvodMarsh ter 
where zap.[Код МО по реестру F003]=ter.[код МО ЕР] 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
---zap.[Код МО по реестру F003] Диспы профы 
---zap.[MCOD] Диспнабы'

set @DActivPol = 'update zap 
set zap.[Действующий полис] = case when po.idpolis is not null then ''' + @odin + ''' 
when po.IDPolis is null and pe.IDPers is not null then ''' + @nol + ''' 
when pe.idpers is null then ''' + @nenaid + ''' 
end 
FROM Inf_Disp zap 
left outer join Pers pe 
on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] and zap.[Дата рождения]=pe.Birthday 
left outer join Polis po on po.[idpers]=pe.[idpers] and po.polisdatef is null where 
zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
--where zap.[Действующий полис] is null'
  
set @DSIZO = 'update zap 
set zap.[Действующий полис]=''' + @Sizo + ''' 
from Inf_Disp zap 
left outer join Pers pe 
on replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] and zap.[Дата рождения]=birthday 
left outer join [rgs].[dbo].[Address] Adr 
on Adr.IDAddressOwner=pe.IDPers 
where (House='''+@home4+''' and Addr like '''+@addr4+''') and (Stroenie='''+@none+''' and Corp='''+@none+''' and Flat='''+@none+''') 
or (House='''+@home1+''' and Addr like '''+@addr1+''') and (Stroenie='''+@none+''' and Corp='''+@none+''' and Flat='''+@none+''') 
or (House='''+@home2+''' and Addr like '''+@addr2+''') and (Stroenie='''+@none+''' and Corp='''+@none+''' and Flat='''+@none+''') 
or (House='''+@home3+''' and Addr like '''+@addr3+''') and (Stroenie='''+@none+''' and Corp='''+@none+''' and Flat='''+@none+''')'

set @DTextSMS = '
declare @SDt nvarchar(max) = (select SMSDisptxt from [dbo].[settings]),
		@NV nvarchar(50) = (select NameVar from [dbo].[settings]),
		@PV nvarchar(50) = (select PhoneVar from [dbo].[settings])
update zap 
set zap.[текст смс]=replace(replace(@SDt,@NV,pe.Name1+'''+@probel+'''+pe.Name2),@PV,ter.[тел для СМС])
from Inf_Disp zap, 
SvodMarsh ter, 
Pers pe 
where replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
and zap.[Дата рождения]=pe.Birthday 
and zap.[Код МО по реестру F003]=ter.[код МО ЕР] 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + '''
'

set @DTextViber = '
declare @VDt nvarchar(max) = (select ViberDisptxt from [dbo].[settings]),
		@NV nvarchar(50) = (select NameVar from [dbo].[settings]),
		@PV nvarchar(50) = (select PhoneVar from [dbo].[settings]),
		@RV nvarchar(50) = (select RespVar from [dbo].[settings])

update zap 
set zap.[текст вайбер]=
case when pe.Sex like ''' + @sex + ''' then replace(replace(replace(@VDt,@NV,pe.Name1+'''+@probel+'''+pe.Name2),@PV,ter.[тел для СМС]),@RV,''' + @obrM + ''')
else replace(replace(replace(@VDt,@NV,pe.Name1+'''+@probel+'''+pe.Name2),@PV,ter.[тел для СМС]),@RV,''' + @obrG + ''')
end 
from Inf_Disp zap, 
SvodMarsh ter, 
Pers pe 
where replace(pe.surname + ''' + @probel + ''' + pe.name1 +''' + @probel + '''+ pe.name2,''' + @io + ''',''' + @e + ''') = zap.[ФИО] 
and zap.[Дата рождения]=pe.Birthday 
and zap.[Код МО по реестру F003]=ter.[код МО ЕР] 
and zap.[Месяц диспансеризации] between ''' + @mounthAt + ''' and ''' + @mounthTo + ''''

exec sp_executesql @DTer,N'' -- Территория
exec sp_executesql @DTels,N'' -- Телефон1, Телефон2, Телефон3
exec sp_executesql @DMobPh3,N'' -- Мобильный по Phone3
exec sp_executesql @DMobPh1,N'' -- Мобильный по Phone1
exec sp_executesql @DMobPh2,N'' -- Мобильный по Phone2
exec sp_executesql @Dmail,N'' -- mail
exec sp_executesql @DbyMob,N'' -- По мобильному
exec sp_executesql @DAdrProz,N'' -- Адрес(по прописке)
exec sp_executesql @DAdrFact,N'' -- Адрес(фактический)
exec sp_executesql @DbyPost,N'' -- по почте
exec sp_executesql @DObz,N'' -- Обзвон
exec sp_executesql @DTelForSms,N'' -- тел для СМС
exec sp_executesql @DActivPol,N'' -- Действующий полис
exec sp_executesql @DSIZO,N'' -- Действующий полис(СИЗО)
exec sp_executesql @DTextSMS,N'' -- текст смс
exec sp_executesql @DTextViber,N'' -- текст вайбер	
END
GO
