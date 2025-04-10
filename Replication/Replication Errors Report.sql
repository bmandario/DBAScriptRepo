
SELECT

   msre.time,

  ma.name AS Name,

   ma.publication,

   ma.publisher_db,

    ma.subscriber_db,

       msre.error_text

FROM   msrepl_errors msre

       INNER JOIN msdistribution_history msh

               ON ( msre.id = msh.error_id )

       INNER JOIN msdistribution_agents ma

               ON ( ma.id = msh.agent_id )


