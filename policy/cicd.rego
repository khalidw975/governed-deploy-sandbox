package main

import rego.v1

# Qi Card × CirrusGo — Governed-Augmentation policy gate (minimal OPA/conftest)
# =============================================================================
# Deterministic gate that the AI cannot mark its own homework against.
# DENY any change that reaches into the cardholder-data (CDE) / payments boundary
# or carries a restricted label. Denied changes are routed to a human CAB gate —
# they NEVER auto-merge. Mirrors policyGate() in the demo driver.
#
# Input shape (change.json):
#   { "id": "...", "author": "...", "paths": ["..."], "labels": ["..."] }
#
# Run locally:   conftest test change.json -p policy/
# Exit non-zero  => required GitHub status check is RED => merge blocked.

# Path substrings that indicate the payments / cardholder-data boundary.
cde_path_patterns := [
	"card-switch",
	"/cde/",
	"payments",
	"hsm",
	"ledger",
	"cardholder",
	"pan",
	"settlement",
]

# Labels that are restricted classes (route to human change-advisory board).
restricted_labels := {"pci-cde", "payments", "card-switch", "infra-topology"}

deny contains msg if {
	some p in input.paths
	some pat in cde_path_patterns
	contains(lower(p), pat)
	msg := sprintf("DENY: path %q is in the cardholder-data / payments boundary (matched %q) -> route to human CAB gate", [p, pat])
}

deny contains msg if {
	some l in input.labels
	l in restricted_labels
	msg := sprintf("DENY: label %q is a restricted class -> route to human CAB gate", [l])
}
