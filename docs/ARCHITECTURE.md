# Architecture

## Purpose

AUDILINK is the Audi manufacturer product face over the shared LINK diagnostics engine. Generic transport, standards, sequencing, safety and shared application behaviour stay in LINK; Audi/VAG-specific identity and evidence belong here.

## Dependency hierarchy

```text
Infiltratr Common
        ↓
       LINK
        ↓
    AUDILINK
```

The build links `audilink-core` publicly against `LINK::Core`. AUDILINK therefore inherits one exact shared dependency chain rather than choosing Common independently.

## Product core

`src/audilink.c` and public headers under `include/audilink/` define product identity and the Audi-facing facade. Local OBD/UDS source areas must remain compatibility/product glue only; standards semantics belong in LINK.

## Platform faces

### Linux

The optional GTK4 shell links AUDILINK::Core and uses LINK's shared Linux shell/adapter support. Product resources, icon and identity remain local.

### Windows

Windows Discover is constructed through LINK's shared native Discover implementation. AUDILINK supplies Audi identity/theme while generic discovery, safety/evidence and Win32 mechanics remain shared.

### iPhone

SwiftUI owns presentation. Objective-C transport/controller code bridges Apple platform mechanics into the shared diagnostic engine. Apple code must not become a private protocol stack.

## Version identity

The root `VERSION` and public AUDILINK version macro must agree at configure time. Version drift is a build failure.

## Tests

- product/version smoke test;
- standard OBD-II product exposure;
- generic diagnostics integration.

These prove the shared standards baseline through AUDILINK. They do not establish Audi/VAG enhanced diagnostic coverage.

## Ownership rule

Audi/VAG-specific VIN/profile/module/network/parameter/procedure knowledge belongs here only when evidence justifies it. Until then, thinness is preferable to guessed catalogue content.
