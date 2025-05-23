select loginame, cpu, memusage, physical_io, * 
  from  master..sysprocesses a
where  exists ( select b.*
     from master..sysprocesses b
    where b.blocked > 0 and
   b.blocked = a.spid ) and not
exists ( select b.*
     from master..sysprocesses b
    where b.blocked > 0 and
   b.spid = a.spid ) 
order by spid