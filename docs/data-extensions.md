# Data Extensions

## `Import_Liste_IT` (staging, Overwrite on each import)

Columns of the list provided by IT. See `samples/import_liste_it.csv`.

| Field | Type | Notes |
|---|---|---|
| ContractId | Text(18) | Contract Id (Service Cloud) |
| ProgrammeRef | Text(50) | Program / campaign reference |
| Email | EmailAddress | |
| Nom | Text(80) | Last name |
| Prenom | Text(80) | First name |
| Telephone | Text(40) | nullable |
| Societe | Text(120) | Company, nullable |
| DateFinProgramme | Date | last day the offer is valid |
| SubscriberKey | Text(254) | |

## `Programme_Contacts` (sending DE + CloudPage lookup)

Populated by `sql/01_generate_programme_contacts.sql` (data action **Update**).
Sendable (SubscriberKey / Email) and used as the sending DE.

| Field | Type | Key | Notes |
|---|---|---|---|
| CleOpaque | Text(36) | **PK** | Lowercase GUID, used in the link |
| ContractId | Text(18) | | |
| ProgrammeRef | Text(50) | | |
| Email | EmailAddress | | |
| Nom | Text(80) | | |
| Prenom | Text(80) | | |
| Telephone | Text(40) | | nullable |
| Societe | Text(120) | | nullable |
| DateFinProgramme | Date | | |
| SubscriberKey | Text(254) | | |
| ImportDate | Date | | |

## `Lead_Log` (cache of leads created by the CloudPage)

| Field | Type | Key | Notes |
|---|---|---|---|
| CleOpaque | Text(36) | **PK** | |
| LeadId | Text(18) | | |
| Token | Text(255) | | lead's funnel token |
| DateCreation | Date | | `Now()` at creation |

No automatic retention: an expired lead is ignored through `DateCreation`, and
the row is overwritten when the lead is recreated.

## `Analyse_Delais_Clic` and `Clics_Suspects` (anti-bot reporting)

Populated by `sql/02_histogramme_delais_clic.sql` and
`sql/03_clics_suspects.sql` (Overwrite). Columns are listed at the top of the
SQL files.

## `Lead_Error_Log` (creation errors and suspicious POSTs)

| Field | Type | Notes |
|---|---|---|
| CleOpaque | Text(36) | |
| ContractId | Text(18) | |
| Message | Text(500) | error, or "SUSPECT: POST n s after send" |
| DateErreur | Date | |

No primary key. Suggested retention: 30 days. Monitor with a report or an alert
(Automation Studio / Verification Activity).
