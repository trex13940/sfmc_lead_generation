# Plan de test (sandbox / BU de test)

Prérequis : DE créées, CloudPage publiée, `@cfgFunnelUrl` pointant vers un
funnel de recette, données de `samples/import_liste_it.csv` importées, SQL
exécuté.

| # | Scénario | Attendu |
|---|---|---|
| 1 | Ouvrir la page sans `k` | « Lien invalide », aucun lead créé |
| 2 | `k` inconnu (36 caractères au hasard) | « Lien invalide » |
| 3 | Clé valide, GET | Page de confirmation, **aucun lead créé** (simule un scanner) |
| 4 | Clé valide, clic sur le bouton | Lead créé, ligne dans `Lead_Log`, redirection vers `…?token=<token>` |
| 5 | Re-cliquer (même clé) | Même token, pas de nouveau lead, 0 appel Retrieve Lead (cache) |
| 6 | Supprimer la ligne de `Lead_Log`, re-cliquer | Lead existant retrouvé via Retrieve, pas de doublon |
| 7 | `DateCreation` ancienne (> 60 j) et lead SF > 60 j | Nouveau lead créé, `Lead_Log` mise à jour |
| 8 | `DateFinProgramme` dans le passé | « Cette offre est terminée » |
| 9 | Retirer `Token__c` du Lead (simuler token vide) | Redirection vers le funnel sans token, ligne dans `Lead_Error_Log` |
| 10 | Révoquer le droit de création Lead à l'utilisateur MC Connect | Repli sans pré-remplissage + `Lead_Error_Log` |
| 11 | Deux clics simultanés (2 onglets) | Au plus 1 lead (sinon voir « Limites » du README) |
| 12 | Lien de l'email (`CloudPagesURL`) modifié à la main | « Lien invalide » |

## Points techniques à vérifier au premier test

- Syntaxe `FormatDate(date, format, "", "fr-BE")` acceptée dans votre BU.
- `RetrieveSalesforceObjects` avec trois filtres (AND) et filtre sur
  `CreatedDate` au format `yyyy-MM-ddTHH:mm:ssZ`.
- Valeur retournée par `CreateSalesforceObject` en cas d'échec (vide ou 0 :
  les deux sont gérés).
- `Redirect()` fonctionne bien avant tout contenu HTML sur la page.
