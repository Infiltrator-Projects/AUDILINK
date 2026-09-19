# Validation

## Evidence model

Build, unit, integration, lifecycle and physical-hardware evidence prove different things and are recorded separately.

## Automated gates

- .github/workflows/ci.yml
- .github/workflows/release.yml

tests/ currently proves generic diagnostics, OBD-II integration and product smoke behaviour. Audi-specific tests should appear with Audi-specific functionality.

## Manual/environment evidence

Physical Audi/VAG vehicles, adapters and network behaviour remain real-hardware evidence boundaries.

Do not promote fixture/simulator/chroot evidence into a broader claim than the environment actually exercised.

## Release/publication criterion

The exact source revision and pinned dependencies/releases intended for publication must pass required gates. Artifacts must be traceable to that identity and documentation must not advertise known-failing or merely planned behaviour.

## Regression rule

Reproducible defects gain permanent automated coverage where practical, at the narrowest layer that captures the failure.
