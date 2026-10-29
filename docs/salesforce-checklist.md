# Checklist côté Salesforce (à valider avec l'admin)

- [ ] **Marketing Cloud Connect** actif dans la BU qui héberge la CloudPage.
- [ ] L'**utilisateur d'intégration MC Connect** peut créer des Leads et lire
      Lead et Contrat (FLS sur tous les champs utilisés).
- [ ] Champs personnalisés sur Lead :
  - `Contract_Ref__c` (Text 18) : Id du contrat
  - `Programme_Ref__c` (Text 50) : référence du programme
  - `Token__c` : token utilisé par le funnel (le nom est configurable dans la
    page : `@cfgTokenField`)
- [ ] **Origine du token** : généré de façon synchrone à l'insertion (trigger
      before/after insert, flow en temps réel ou champ formule). Un traitement
      asynchrone rend le token vide juste après la création et déclenche le
      repli sans pré-remplissage.
- [ ] **Automatisations sur création de Lead** (règles d'assignation, flows,
      notifications aux commerciaux) : vérifier qu'elles sont voulues, ou les
      neutraliser pour `LeadSource = 'Programme migration'`.
- [ ] `Company` est obligatoire : la page met « Particulier » quand `Societe`
      est vide.
- [ ] Impact sur les **quotas API** : 1 à 3 appels par clic « confirmé »,
      0 pour les clics répétés grâce à `Lead_Log`.
- [ ] Validité du lead : confirmer que les 70 jours se comptent depuis
      `CreatedDate` (sinon adapter le filtre et `@cfgMaxAgeDays`).
- [ ] Unicité : un External ID unique sur Lead empêcherait de recréer un lead
      après expiration, sauf nettoyage du champ sur les leads expirés.
      Le dédoublonnage repose donc sur `Lead_Log` + Retrieve.
