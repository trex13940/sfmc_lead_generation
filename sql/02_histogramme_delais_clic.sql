/* Automation Studio - SQL Query Activity
   Target: Analyse_Delais_Clic, data action "Overwrite"
   (columns: Ordre int, Tranche varchar(20), NbClics int, NbAbonnes int)

   Distribution of the delay between the send (_Sent) and the click (_Click)
   on the program link. Used to choose @cfgMinSeconds: bots form a clear peak
   in the first buckets.
   Adjust LinkName (alias of the link in the email) and the period. */

SELECT
    d.Ordre,
    d.Tranche,
    COUNT(*)                      AS NbClics,
    COUNT(DISTINCT d.SubscriberKey) AS NbAbonnes
FROM (
    SELECT
        c.SubscriberKey,
        CASE
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 0     THEN 0
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 5     THEN 1
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 10    THEN 2
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 30    THEN 3
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 60    THEN 4
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 300   THEN 5
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 3600  THEN 6
            ELSE 7
        END AS Ordre,
        CASE
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 0     THEN 'negative'
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 5     THEN '0-4 s'
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 10    THEN '5-9 s'
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 30    THEN '10-29 s'
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 60    THEN '30-59 s'
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 300   THEN '1-5 min'
            WHEN DATEDIFF(second, s.EventDate, c.EventDate) < 3600  THEN '5-60 min'
            ELSE '> 1 h'
        END AS Tranche
    FROM _Click c
    INNER JOIN _Sent s
            ON s.JobID        = c.JobID
           AND s.ListID       = c.ListID
           AND s.BatchID      = c.BatchID
           AND s.SubscriberID = c.SubscriberID
    WHERE c.LinkName  = 'CTA_Programme_Migration'
      AND c.EventDate >= DATEADD(day, -90, GETDATE())
) d
GROUP BY d.Ordre, d.Tranche
