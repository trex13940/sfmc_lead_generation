# Salesforce-side checklist (to validate with the admin)

- [ ] **Marketing Cloud Connect** is enabled in the business unit hosting the
      CloudPage.
- [ ] The **MC Connect integration user** can create Leads and read Lead and
      Contract (field-level security on every field used).
- [ ] Custom fields on Lead:
  - `Contract_Ref__c` (Text 18): contract Id
  - `Programme_Ref__c` (Text 50): program reference
  - `Token__c`: token used by the funnel (the name is configurable in the page:
    `@cfgTokenField`)
- [ ] **Token origin**: generated synchronously on insert (before/after insert
      trigger, record-triggered flow or formula field). An asynchronous process
      leaves the token empty right after creation and triggers the fallback
      without pre-fill.
- [ ] **Automations on Lead creation** (assignment rules, flows, notifications to
      sales): check they are wanted, or bypass them for
      `LeadSource = 'Programme migration'`.
- [ ] `Company` is required: the page uses "Particulier" when `Societe` is empty.
- [ ] Impact on **API quotas**: 1 to 3 calls per confirmed click, 0 for repeated
      clicks thanks to `Lead_Log`.
- [ ] Lead validity: confirm that the 70 days are counted from `CreatedDate`
      (otherwise adapt the filter and `@cfgMaxAgeDays`).
- [ ] Uniqueness: a unique External ID on Lead would prevent recreating a lead
      after expiry, unless the field is cleared on expired leads.
      Duplicate prevention therefore relies on `Lead_Log` + Retrieve.
