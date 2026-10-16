# Architecture

## Purpose

AUDILink is the Audi manufacturer product face over the shared Link diagnostics engine. Generic transport, standards, sequencing, safety and shared application behaviour stay in Link; Audi/VAG-specific identity and evidence belong here.

## Dependency hierarchy

```text
Libraries
        ↓
       Link
        ↓
    AUDILink
```

The build links `audilink-core` publicly against `Link::Core`. AUDILink therefore inherits one exact shared dependency chain rather than choosing Common independently.

## Product core

`src/audilink.c` and public headers under `include/audilink/` define product identity and the Audi-facing facade. Local OBD/UDS source areas must remain compatibility/product glue only; standards semantics belong in Link.

## Platform faces

### Linux

The optional GTK4 shell links AUDILink::Core and uses Link's shared Linux shell/adapter support. Product resources, icon and identity remain local.

### Windows

Windows Discover is constructed through Link's shared native Discover implementation. AUDILink supplies Audi identity/theme while generic discovery, safety/evidence and Win32 mechanics remain shared.

### iPhone

SwiftUI owns presentation. Objective-C transport/controller code bridges Apple platform mechanics into the shared diagnostic engine. Apple code must not become a private protocol stack.

## Version identity

The root `VERSION` and public AUDILink version macro must agree at configure time. Version drift is a build failure.

## Tests

- product/version smoke test;
- standard OBD-II product exposure;
- generic diagnostics integration.

These prove the shared standards baseline through AUDILink. They do not establish Audi/VAG enhanced diagnostic coverage.

## Ownership rule

Audi/VAG-specific VIN/profile/module/network/parameter/procedure knowledge belongs here only when evidence justifies it. Until then, thinness is preferable to guessed catalogue content.

## Build boundaries

`BUILD_TESTING` is the caller-owned CMake switch. The product registers its own tests only when enabled and never rewrites that cache setting while adding Link. Link owns its test policy independently. Apple packages receive the actual checked-out Link commit through `LINK_SOURCE_REVISION`; a direct Xcode build without that input reports an unavailable revision instead of a stale hard-coded SHA. Manufacturer code and identity remain product-owned.
