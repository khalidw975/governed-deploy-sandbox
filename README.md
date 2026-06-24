# governed-deploy-sandbox

Generic, throwaway sandbox for a **governed-augmentation** CI/CD demo. **No client data.**

- `policy/cicd.rego` — the policy gate: DENY any change touching the payments / cardholder-data boundary or carrying a restricted label.
- `.github/workflows/policy-gate.yml` — runs the gate (conftest) on every PR; it is a **required status check**, so a denied change cannot merge.
- A non-payments PR passes and is mergeable by a human; a payments-tagged PR fails the gate and is blocked.

Created by the CirrusGo demo kit. Delete with `bun teardown-sandbox.ts`.
