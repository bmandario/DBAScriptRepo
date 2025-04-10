--Run on USPLPDWSQL1112.na.bpww.org
--Edit WHERE clause to include tables to drop
USE [Fusion_Core]
GO

SELECT 'EXEC sp_dropsubscription @publication = ''' + pub.name + ''', @article = ''' + art.name + ''', @subscriber = ''' + sub.srvname + '''
GO'
,'EXEC sp_droparticle @publication  = ''' + pub.name + ''', @article = ''' + art.name + '''
GO'
FROM syssubscriptions sub with (nolock) INNER JOIN sysarticles art with (nolock) on sub.artid = art.artid 
INNER JOIN syspublications pub with (nolock) on art.pubid = pub.pubid
WHERE art.name 
in (
'LCDInstallationType'
)
ORDER BY pub.name, sub.srvname, art.name