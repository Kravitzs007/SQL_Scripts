/******
Developer	:	Styvenson Jeanlys

Objective	:	The purpose of this script is to attain 
				the database object that has a particular keyword. 
*/

use master;

declare @names varchar(256) 
declare @dbname varchar(32) 
declare @sql varchar(8000) 
declare @searchkey varchar (30)

--search function, stored procs, tables for a particular word
set @searchkey = 'dbo.Up_SelectSiteIssues';

declare dbnames cursor 
for 
select name from master.dbo.sysdatabases 

open dbnames 
fetch next from dbnames into @names 
while (@@FETCH_STATUS=0) 
begin 

set @sql = 'USE '+@names+ ' SELECT DISTINCT [DATABASE]   = '+char(39)+@names+char(39)+
							 ',[NAME]	= NAME, 
							[TYPE]	= CASE xtype
										WHEN ''P'' THEN''STORED PROC''
										WHEN''U'' THEN''USER TABLE''
										WHEN''S'' THEN''SYSTEM TABLE''
										WHEN''V'' THEN''VIEW''
										WHEN''X'' THEN''EXTENDED STORED PROC''
										ELSE xtype END
			FROM sysobjects ob
			INNER JOIN syscomments ct ON ob.id = ct.id
			WHERE text Like '+char(39)+'%'+@searchkey +'%'+char(39)
exec (@sql) 
if (@@rowcount>0) 
begin 
select @dbname 
end 
fetch next from dbnames into @names 
end 
close dbnames 
deallocate dbnames 
