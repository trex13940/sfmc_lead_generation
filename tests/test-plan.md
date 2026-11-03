# Test plan (sandbox / test business unit)

Prerequisites: DEs created, CloudPage published, `@cfgFunnelUrl` pointing to a
test funnel, data from `samples/import_liste_it.csv` imported, SQL executed.

| # | Scenario | Expected |
|---|---|---|
| 1 | Open the page without `k` | Redirect to `<funnel>?partner=hesitating`, no lead created |
| 2 | Unknown `k` (36 random characters) | Redirect to `<funnel>?partner=hesitating` |
| 3 | Valid key, GET | Confirmation page, **no lead created** (simulates a scanner) |
| 4 | Valid key, click the button | Lead created, row in `Lead_Log`, redirect to `…?token=<token>` |
| 5 | Click again (same key) | Same token, no new lead, 0 Lead Retrieve calls (cache) |
| 6 | Delete the `Lead_Log` row, click again | Existing lead found via Retrieve, no duplicate |
| 7 | Old `DateCreation` (> 60 days) and SF lead > 60 days | New lead created, `Lead_Log` updated |
| 8 | `DateFinProgramme` in the past | Redirect to `<funnel>?partner=hesitating`, no lead created |
| 9 | Remove `Token__c` from the Lead (simulate empty token) | Redirect to `<funnel>?partner=hesitating` (no token), row in `Lead_Error_Log` |
| 10 | Revoke Lead create permission from the MC Connect user | Redirect to `<funnel>?partner=hesitating` + `Lead_Error_Log` |
| 11 | Two simultaneous clicks (2 tabs) | At most 1 lead (otherwise see "Known limitations" in the README) |
| 12 | Email link (`CloudPagesURL`) edited by hand | Redirect to `<funnel>?partner=hesitating` |
| 13 | Click the button less than 5 s after the send (test send, immediate click) | No lead, confirmation page shown again, "SUSPECT" row in `Lead_Error_Log` |
| 14 | Same test with `@cfgMinSeconds = 0` | Lead created normally |
| 15 | Link without parameter `t` (old link, preview) | No delay check, normal behaviour |

## Technical points to verify on first test

- `FormatDate(date, format, "", "fr-BE")` syntax accepted in your business unit.
- `RetrieveSalesforceObjects` with three filters (AND) and a filter on
  `CreatedDate` in the format `yyyy-MM-ddTHH:mm:ssZ`.
- `GetSendTime()`: non-empty on a real send, same time zone as `Now()` (the
  computed delay must be positive and plausible; otherwise adjust).
- SSJS block (`Platform.Load`, regex) runs in the CloudPage and the variable
  `@secsSinceSend` is correctly set.
- Value returned by `CreateSalesforceObject` on failure (empty or 0: both are
  handled).
- `Redirect()` works before any HTML content on the page.
