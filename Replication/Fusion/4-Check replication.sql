use [Fusion_Core]
select sub.artid, art.name, sub.dest_db, sub.srvname as SubServer, art.pubid, pub.name as pubName, sub.login_name

from syssubscriptions sub with (nolock) inner join sysarticles art with (nolock) on sub.artid = art.artid 

inner join syspublications pub with (nolock) on art.pubid = pub.pubid

where art.name 

in ('AsnDetailSkuLog','AsnDetailDeviceSerialChangeLog')

