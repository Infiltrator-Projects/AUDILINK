# Validation

## Current automated evidence

AUDILink CI builds the product against its exact Link dependency and directly tests:

- product/version smoke integration;
- OBD-II facade behaviour;
- generic diagnostic flow.

Platform workflows also compile/package the supported product faces.

## What this proves

This establishes that AUDILink is a working Link-backed product and that generic standards behaviour is exposed correctly.

It does not prove Audi/VAG-specific module topology, proprietary parameters, routing conventions or enhanced procedures.

## Manufacturer evidence levels

1. authoritative/public documented source;
2. sanitised capture with known vehicle/module context;
3. repeatable physical-vehicle observation;
4. regression fixture derived from verified evidence.

A generic protocol assumption without Audi/VAG evidence remains generic.

## Safety validation

Any manufacturer-specific request permission added here requires product-level tests proving its scope. Codec availability in Link is not permission.

## Physical validation

Real Bluetooth/J2534/vehicle behaviour requires physical adapters and vehicles. Hosted builds and simulator tests are integration evidence only.

## Release criterion

The exact AUDILink source and Link gitlink must pass required gates. Documentation must not describe planned or generic-only behaviour as verified manufacturer capability.

## Qualified publication

`VERSION` is the sole release-intent authority. CI builds and tests each distributable once, then preserves per-platform SHA-256 manifests and the exact source commit. The release workflow downloads only artifacts from that successful push-to-`main` run; it never recompiles. A draft is byte-compared before publication and the public release is compared again. Published tags and bytes remain immutable. Windows qualification retains the x86 executable required by J2534 and runs its real window/title/close test on a clean x64 Windows runner. Native Linux verification remains separate from the generic public package.
