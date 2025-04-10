select art.pubid, pub.name as pubName, substring(art.ins_cmd,16,3) as source_schema_3letter,
sub.artid, art.name, art.dest_owner as dest_schema, sub.dest_db, sub.srvname as SubServer,
case pub.repl_freq when 0 then 'Transactional' when 1 then 'snapshot' end ReplType,
sub.login_name
from syssubscriptions sub with (nolock) inner join sysarticles art with (nolock)
on sub.artid = art.artid inner join syspublications pub with (nolock) on art.pubid = pub.pubid
--where pub.name = 'BlueIQ_Pub_Detail_Customer'