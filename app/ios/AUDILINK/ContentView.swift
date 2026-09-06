// SPDX-License-Identifier: GPL-3.0-or-later
import SwiftUI

private let productTheme = LinkDiagnosticTheme(
    backgroundTop: Color(red: 0.025, green: 0.027, blue: 0.032),
    backgroundMiddle: Color(red: 0.055, green: 0.060, blue: 0.068),
    backgroundBottom: Color(red: 0.085, green: 0.090, blue: 0.10),
    panel: Color(red: 0.08, green: 0.09, blue: 0.10),
    panelRaised: Color(red: 0.12, green: 0.13, blue: 0.145),
    primaryText: Color(red: 0.95, green: 0.96, blue: 0.97),
    secondaryText: Color(red: 0.66, green: 0.68, blue: 0.71),
    mutedText: Color(red: 0.66, green: 0.68, blue: 0.71).opacity(0.72),
    border: Color(red: 0.34, green: 0.35, blue: 0.37).opacity(0.72),
    accent: Color(red: 0.84, green: 0.07, blue: 0.17),
    success: Color(red: 0.34, green: 0.78, blue: 0.48),
    warning: Color(red: 0.95, green: 0.68, blue: 0.25),
    fault: Color(red: 0.90, green: 0.18, blue: 0.25),
    typography: LinkDiagnosticTypography(
        display: .system(size: 29, weight: .semibold),
        body: .body,
        bodyBold: .body.bold(),
        subheadline: .subheadline,
        subheadlineBold: .subheadline.bold(),
        headline: .headline,
        caption: .caption,
        captionBold: .caption.bold(),
        caption2: .caption2,
        caption2Bold: .caption2.bold(),
        title3: .title3,
        title2: .title2.bold()))

private let productAppearance = LinkStandardProductAppearance(
    productName: "AUDILINK",
    manufacturerName: "Audi",
    subtitle: "AUDI · LINK DIAGNOSTICS",
    emblemAssetName: "AUDILINKEmblem",
    theme: productTheme,
    summary: "Open-source Audi diagnostics built as a branded product face on the shared LINK engine.",
    authors: ["Shannon Smith"],
    copyrightShort: "© 2026 Shannon Smith",
    copyrightFull: "Copyright © 2026 Shannon Smith",
    website: URL(string: "https://github.com/Infiltrator-Projects/AUDILINK"),
    licenseName: "GPL-3.0-or-later",
    licenseText: "AUDILINK is free software licensed under GNU GPL v3 or later. See LICENSE in the source package for the complete licence text.",
    credits: ["Shannon Smith — Author and project maintainer"])

struct ContentView: View {
    @StateObject private var model = ConnectionViewModel()

    var body: some View {
        LinkStandardProductContentView(
            model: model,
            appearance: productAppearance)
    }
}
