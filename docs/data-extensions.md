# Data Extensions

## `Import_Liste_IT` (staging, Overwrite à chaque import)

Colonnes de la liste fournie par l'IT. Voir `samples/import_liste_it.csv`.

| Champ | Type | Remarque |
|---|---|---|
| ContractId | Text(18) | Id du contrat (Service Cloud) |
| ProgrammeRef | Text(50) | Référence du programme / de la campagne |
| Email | EmailAddress | |
| Nom | Text(80) | |
| Prenom | Text(80) | |
| Telephone | Text(40) | nullable |
| Societe | Text(120) | nullable |
| DateFinProgramme | Date | dernier jour de validité de l'offre |
| SubscriberKey | Text(254) | |

## `Programme_Contacts` (envoi + lookup de la CloudPage)

Alimentée par `sql/01_generate_programme_contacts.sql` (action **Update**).
Sendable (SubscriberKey / Email) et utilisée comme DE d'envoi.

| Champ | Type | Clé | Remarque |
|---|---|---|---|
| CleOpaque | Text(36) | **PK** | GUID minuscule, utilisé dans le lien |
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

## `Lead_Log` (cache des leads créés par la CloudPage)

| Champ | Type | Clé | Remarque |
|---|---|---|---|
| CleOpaque | Text(36) | **PK** | |
| LeadId | Text(18) | | |
| Token | Text(255) | | token funnel du lead |
| DateCreation | Date | | `Now()` à la création |

Pas de rétention automatique : un lead expiré est ignoré via `DateCreation`,
et la ligne est écrasée à la recréation.

## `Lead_Error_Log` (erreurs de création)

| Champ | Type | Remarque |
|---|---|---|
| CleOpaque | Text(36) | |
| ContractId | Text(18) | |
| Message | Text(500) | |
| DateErreur | Date | |

Sans clé primaire. Rétention conseillée : 30 jours. À surveiller par un
rapport ou une alerte (Automation Studio / Verification Activity).
