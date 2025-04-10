
SELECT a.name, a.recovery_model_desc, [Full] as Last_Full, [Diff] as Last_Diff, [Log] as Last_Log

FROM sys.databases a left join

(select

        database_name,

        backup_type =

            case type

                when 'D' then 'Full'

                when 'L' then 'Log'

                when 'I' then 'Diff'

                else 'other'

            end,

max(backup_finish_date) as backup_finish_date   

    from msdb.dbo.backupset

group by database_name, type) as source

PIVOT (

MAX (backup_finish_date)

FOR backup_type IN ([Full], [Diff], [Log] )

) as pvt



on a.name = pvt.database_name

where a.name <> 'Tempdb'