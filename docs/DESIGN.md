# Design

## First-principles position

AUDILINK should be an Audi product, not a fork of LINK with duplicated generic diagnostics.

## Goals

- reuse one protocol/safety/application engine across vehicle products;
- add Audi/VAG-specific knowledge only from traceable evidence;
- keep Linux, Windows and iPhone faces over one product core;
- preserve unknown/unsupported states instead of guessing;
- inherit deny-by-default request safety from LINK.

## Thin-product rule

Generic OBD, UDS, ISO-TP, transport and common UI sequencing belong in LINK even when AUDILINK is the first product that needs an improvement.

A small manufacturer repository is not incomplete merely because shared behaviour lives below it.

## Evidence rule

Audi/VAG-specific definitions require evidence with known scope. A generic UDS DID/service number is not enough to assert Audi meaning. Captures or external-tool observations are evidence to reconcile, not data to copy blindly.

## Platform rule

C/C++ are preferred for first-party native/domain code. Swift and Objective-C remain legitimate Apple boundaries. Platform shells should render and adapt shared state rather than duplicate diagnostic sequencing.

## Failure rule

Unknown manufacturer values stay raw or unavailable. Failed scanning remains different from a clean scan. Adding a decoder does not enable its request automatically.

## Shared-improvement rule

When a needed capability is generic, improve LINK and remove local duplication once LINK's implementation is at least as strong.
