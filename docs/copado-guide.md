# Mapping This Pipeline to Copado

This repo implements a Salesforce CI/CD pipeline with plain Git and GitHub Actions. Copado is a commercial DevOps platform built for Salesforce that covers the same ground with a managed UI. This guide maps each part of this pipeline to its Copado equivalent, so the concepts carry over in either direction.

## Concept map

| This repo (GitHub Actions + SF CLI) | Copado equivalent |
| --- | --- |
| Feature branch (`feature/*`) | User Story, which gets its own feature branch |
| Committing metadata to the branch | User Story **Commit** (selecting metadata in the UI, or committing from the CLI or VS Code extension) |
| Pull request into `main` | **Promotion** from one pipeline environment to the next |
| `validate-pr.yml`: scratch org, deploy, Apex tests | **Validation** deployment plus **Quality Gates** (Apex tests, static code analysis) |
| `deploy-on-merge.yml`: deploy to the org after merge | **Deployment** step of a promotion to the destination environment |
| `production` GitHub environment with required reviewers | Approval steps on the promotion or deployment |
| `main` branch | The branch tied to the production environment in the **Pipeline** |
| GitHub secrets holding JWT credentials | **Credentials** (org authentication) stored on each Environment |
| Merging `main` back into feature branches | **Back-promotion** |

## Pipeline shape

This repo uses a two-stage flow:

```
feature/* ──PR──▶ main ──merge──▶ target org
   │                │
   └─ validate-pr   └─ deploy-on-merge
      (scratch org)    (RunLocalTests)
```

A typical Copado pipeline adds intermediate environments:

```
Dev ──▶ Integration (QA) ──▶ UAT ──▶ Production
```

To extend this repo the same way, add long-lived branches (for example `qa` and `uat`), one deploy workflow per branch with its own credentials, and a matching GitHub environment for each with its own approval rules.

## What Copado adds on top

- **Metadata selection in the UI.** Admins can commit declarative changes without using Git directly.
- **Conflict resolution.** Copado detects and helps resolve metadata conflicts between user stories before promotion.
- **Selective deployment.** It promotes individual user stories instead of whole branches.
- **Back-promotion tracking.** It shows which stories are missing from lower environments.
- **Built-in compliance and audit trail.** It links each change to a story, approver and deployment record.

## What stays the same

- Metadata lives in source format under `force-app/`.
- Deployments run Apex tests (`RunLocalTests` or specified tests) and must meet the 75% org coverage requirement for production.
- Authentication to orgs uses connected apps / OAuth.
- Changes should be validated before they reach production.

## Running this repo's workflow locally

The CI steps are plain Salesforce CLI commands, so you can reproduce them locally:

```bash
# Validate (what validate-pr.yml does)
sf org create scratch --definition-file config/project-scratch-def.json --alias local-scratch --duration-days 1
sf project deploy start --target-org local-scratch
sf apex run test --target-org local-scratch --code-coverage --result-format human --wait 20
sf org delete scratch --target-org local-scratch --no-prompt

# Dry-run a deploy to the real org without saving changes
sf project deploy validate --target-org <alias> --test-level RunLocalTests
```
