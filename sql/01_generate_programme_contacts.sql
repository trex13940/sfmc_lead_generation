/* Automation Studio - SQL Query Activity
   Source : Import_Liste_IT (liste fournie par l'IT)
   Cible  : Programme_Contacts, action "Update" (ne jamais Overwrite)

   La clé opaque existante est conservée à chaque réimport, de façon à ce que
   les liens déjà envoyés restent valides pendant toute la durée du programme. */

SELECT
    COALESCE(p.CleOpaque, LOWER(CAST(NEWID() AS VARCHAR(36)))) AS CleOpaque,
    i.ContractId,
    i.ProgrammeRef,
    i.Email,
    i.Nom,
    i.Prenom,
    i.Telephone,
    i.Societe,
    i.DateFinProgramme,
    i.SubscriberKey,
    GETDATE() AS ImportDate
FROM Import_Liste_IT i
LEFT JOIN Programme_Contacts p
       ON p.ContractId   = i.ContractId
      AND p.ProgrammeRef = i.ProgrammeRef
