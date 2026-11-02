/* Automation Studio - SQL Query Activity
   Cible : Clics_Suspects, action "Overwrite"
   (colonnes : SubscriberKey varchar(254), JobID int, LinkName varchar(200),
    DateClic datetime, DelaiSecondes int)

   Clics faits moins de 5 secondes après l'envoi : à exclure des statistiques
   de clic. Aligner le seuil sur @cfgMinSeconds de la CloudPage une fois
   l'histogramme (02) analysé. */

SELECT
    c.SubscriberKey,
    c.JobID,
    c.LinkName,
    c.EventDate AS DateClic,
    DATEDIFF(second, s.EventDate, c.EventDate) AS DelaiSecondes
FROM _Click c
INNER JOIN _Sent s
        ON s.JobID        = c.JobID
       AND s.ListID       = c.ListID
       AND s.BatchID      = c.BatchID
       AND s.SubscriberID = c.SubscriberID
WHERE c.LinkName  = 'CTA_Programme_Migration'
  AND c.EventDate >= DATEADD(day, -90, GETDATE())
  AND DATEDIFF(second, s.EventDate, c.EventDate) < 5
