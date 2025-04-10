DECLARE @adGroup NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

IF OBJECT_ID('tempdb..#indiv_logins') IS NOT NULL
    DROP TABLE #indiv_logins;

CREATE TABLE #indiv_logins
(
    [account_name] NVARCHAR(255),
    [type] NVARCHAR(255),
    [privilege] NVARCHAR(255),
    [mapped_login name] NVARCHAR(255),
    [permission path] NVARCHAR(255)
);

DECLARE db_cursor CURSOR FOR
SELECT adGroup
FROM (VALUES
    ('CORPORATE\AWS_GDW')
    , ('CORPORATE\CN-IT')
    , ('CORPORATE\IM_MNL_SCE_SUPPORT_ADM')
    , ('CORPORATE\IM_MNL_SCE_SUPPORT_READ')
    , ('CORPORATE\NA_IM_IWM_Dev')
    , ('CORPORATE\NA_IM_SCE_ADMIN')
    , ('CORPORATE\NA_IM_SCE_READ')
    , ('CORPORATE\NA-BIC-SpecAccess')
    , ('CORPORATE\US_OPEX')
    , ('CORPORATE\NA_IM_SQL_ADM')
    ) As adGroups(adGroup); -- Change as needed

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @adGroup

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
        INSERT INTO #indiv_logins([account_name], [type], [privilege], [mapped_login name], [permission path])
        EXEC XP_LOGININFO ''' + @adGroup +''', ''members'';
        '

    EXEC sp_executesql @sql
    FETCH NEXT FROM db_cursor INTO @adGroup
END

CLOSE db_cursor
DEALLOCATE db_cursor

SELECT *
FROM #indiv_logins;

DROP TABLE #indiv_logins;