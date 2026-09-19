# Validation

## Current automated evidence

AUDILINK CI builds the product against its exact LINK dependency and directly tests:

- product/version smoke integration;
- OBD-II facade behaviour;
- generic diagnostic flow.

Platform workflows also compile/package the supported product faces.

## What this proves

This establishes that AUDILINK is a working LINK-backed product and that generic standards behaviour is exposed correctly.

It does not prove Audi/VAG-specific module topology, proprietary parameters, routing conventions or enhanced procedures.

## Manufacturer evidence levels

1. authoritative/public documented source;
2. sanitised capture with known vehicle/module context;
3. repeatable physical-vehicle observation;
4. regression fixture derived from verified evidence.

A generic protocol assumption without Audi/VAG evidence remains generic.

## Safety validation

Any manufacturer-specific request permission added here requires product-level tests proving its scope. Codec availability in LINK is not permission.

## Physical validation

Real Bluetooth/J2534/vehicle behaviour requires physical adapters and vehicles. Hosted builds and simulator tests are integration evidence only.

## Release criterion

The exact AUDILINK source and LINK gitlink must pass required gates. Documentation must not describe planned or generic-only behaviour as verified manufacturer capability.
