# Decisions

## ADR-001 — AUDILINK stays thin over LINK

**Decision.** Product-neutral diagnostic behaviour remains in LINK.

**Rationale.** Shared standards and safety fixes must not diverge by manufacturer.

**Consequence.** AUDILINK grows mainly through Audi/VAG-specific evidence and presentation.

## ADR-002 — One dependency chain defines the build

**Decision.** AUDILINK pins LINK and does not independently select Common.

**Rationale.** Mixed shared foundations would weaken reproducibility.

**Consequence.** Shared dependency updates are reviewed through the LINK gitlink.

## ADR-003 — Generic standards support is not Audi-specific evidence

**Decision.** Passing generic OBD/UDS flows does not make a manufacturer definition verified.

**Rationale.** Audi/VAG diagnostic meaning may layer conventions or routing above the standard service.

**Consequence.** Product documentation distinguishes baseline standards coverage from enhanced manufacturer coverage.

## ADR-004 — Platform faces adapt; they do not fork diagnostics

**Decision.** GTK, Win32 and SwiftUI/Objective-C code remains presentation/provider integration.

**Rationale.** Cross-platform behaviour should come from the shared engine.

**Consequence.** Diagnostic fixes normally belong below platform shells.

## ADR-005 — Version drift is rejected at configure time

**Decision.** VERSION and the public product-version macro must agree.

**Rationale.** Build/package/API identities must describe the same source.

**Consequence.** Inconsistent version metadata cannot silently ship.
