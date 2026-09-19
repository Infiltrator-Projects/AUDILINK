# Design

## First-principles position

AUDILINK is designed from the behaviour it must own. Existing tools, standards and hosted services are evidence or mechanisms, not specifications to clone or dependencies allowed to redefine project policy.

## Goals

- remain a thin manufacturer face over LINK
- add Audi/VAG knowledge only from traceable evidence
- avoid private generic protocol/application copies
- keep unsupported manufacturer behaviour explicit

## Non-goals

Generic OBD success does not constitute Audi manufacturer coverage, and unverified VAG definitions are not guessed merely to populate a catalogue.

## Dependency policy

Prefer first-party C/C++ implementation for portable/native logic where appropriate and exact pinned first-party shared dependencies for common contracts. External tools/services are acceptable when their interface is useful and replaceable; semantics remain documented and testable in this repository.

## Failure philosophy

Missing, unsupported, stale and failed are distinct states. The project prefers a visible refusal or unavailable result to manufacturing a plausible success. Destructive/publication/manufacturer actions require stronger evidence than read-only discovery.

## Decision quality

A design change should identify ownership, alternatives, evidence and validation. Newness alone is not a benefit; a change should improve correctness, resilience, safety, performance, fidelity or maintainability.
