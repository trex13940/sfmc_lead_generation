/* Automation Studio - SQL Query Activity
   Target: Clics_Suspects, data action "Overwrite"
   (columns: SubscriberKey varchar(254), JobID int, LinkName varchar(200),
    DateClic datetime, DelaiSecondes int)

   Clicks made less than 5 seconds after the send: to be excluded from click
   statistics. Align the threshold with @cfgMinSeconds in the CloudPage once
   the histogram (02) has been analysed. */

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
