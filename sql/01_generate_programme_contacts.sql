/* Automation Studio - SQL Query Activity
   Source: Import_Liste_IT (list provided by IT)
   Target: Programme_Contacts, data action "Update" (never Overwrite)

   The existing opaque key is kept on every re-import, so that links already
   sent remain valid for the whole duration of the program. */

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
