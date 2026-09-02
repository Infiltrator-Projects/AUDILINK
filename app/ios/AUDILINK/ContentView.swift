// SPDX-License-Identifier: GPL-3.0-or-later
import SwiftUI

private enum ProductTheme {
    static let backgroundTop = Color(red: 0.025, green: 0.027, blue: 0.032)
    static let backgroundBottom = Color(red: 0.07, green: 0.075, blue: 0.085)
    static let panel = Color(red: 0.08, green: 0.09, blue: 0.10)
    static let border = Color(red: 0.28, green: 0.30, blue: 0.33)
    static let accent = Color(red: 0.82, green: 0.06, blue: 0.16)
    static let primary = Color(red: 0.95, green: 0.96, blue: 0.97)
    static let secondary = Color(red: 0.66, green: 0.68, blue: 0.71)
}

private let audiLinkTheme = LinkDiagnosticTheme(
    backgroundTop: ProductTheme.backgroundTop,
    backgroundMiddle: ProductTheme.panel,
    backgroundBottom: ProductTheme.backgroundBottom,
    panel: ProductTheme.panel,
    panelRaised: ProductTheme.border.opacity(0.35),
    primaryText: ProductTheme.primary,
    secondaryText: ProductTheme.secondary,
    mutedText: ProductTheme.secondary.opacity(0.72),
    border: ProductTheme.border,
    accent: ProductTheme.accent,
    success: .green,
    warning: .orange,
    fault: .red,
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

private struct Panel<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline).foregroundStyle(ProductTheme.primary)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(ProductTheme.panel))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(ProductTheme.border))
    }
}

struct ContentView: View {
    @StateObject private var model = ConnectionViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [ProductTheme.backgroundTop, ProductTheme.backgroundBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("AUDILINK").font(.largeTitle.bold()).foregroundStyle(ProductTheme.primary)
                                Text("Audi diagnostics · LINK standards core").foregroundStyle(ProductTheme.secondary)
                            }
                            Spacer()
                            Text(model.versionText).font(.caption.monospaced()).foregroundStyle(ProductTheme.secondary)
                        }

                        Panel("Connection") {
                            Text(model.statusText)
                            Text(model.peripheralName).foregroundStyle(ProductTheme.secondary)
                            Text(model.adapterIdentifier).font(.caption.monospaced()).foregroundStyle(ProductTheme.secondary)
                            Button(model.isActive ? "Disconnect" : "Connect") {
                                model.isActive ? model.disconnect() : model.connect()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(ProductTheme.accent)
                        }

                        Panel("OBD") {
                            NavigationLink {
                                LinkStandardObdView(snapshot: obdSnapshot)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(model.diagnosticCapabilityText)
                                            .font(.headline)
                                            .foregroundStyle(ProductTheme.primary)
                                        Text("Open LINK standard diagnostics")
                                            .font(.caption)
                                            .foregroundStyle(ProductTheme.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(ProductTheme.accent)
                                }
                            }
                            .buttonStyle(.plain)
                        }

                        Panel("Vehicle") {
                            Text("VIN").font(.caption).foregroundStyle(ProductTheme.secondary)
                            Text(model.vehicleVINText).font(.body.monospaced())
                            Text("Readiness").font(.caption).foregroundStyle(ProductTheme.secondary)
                            Text(model.readinessStatusText)
                        }

                        Panel("Fault memory") {
                            Text(model.faultScanStatusText).foregroundStyle(ProductTheme.secondary)
                            faultGroup("Stored", model.storedDTCs)
                            faultGroup("Pending", model.pendingDTCs)
                            faultGroup("Permanent", model.permanentDTCs)
                        }

                        Panel("Live data") {
                            if model.standardLiveRows.isEmpty {
                                Text("Waiting for advertised SAE live parameters.").foregroundStyle(ProductTheme.secondary)
                            } else {
                                ForEach(model.standardLiveRows, id: \.self) { row in
                                    Text(row).font(.subheadline.monospacedDigit())
                                    Divider().overlay(ProductTheme.border)
                                }
                            }
                        }

                        Panel("Evidence") {
                            Text("\(model.recordedSampleCount) samples recorded")
                            Button("Prepare diagnostic evidence CSV") { model.prepareCSVExport() }
                                .tint(ProductTheme.accent)
                            if let url = model.csvExportURL {
                                ShareLink(item: url) {
                                    Label("Share CSV", systemImage: "square.and.arrow.up")
                                }
                                .tint(ProductTheme.accent)
                            }
                        }
                    }
                    .padding()
                }
            }
            .foregroundStyle(ProductTheme.primary)
            .tint(ProductTheme.accent)
        }
        .linkDiagnosticTheme(audiLinkTheme)
        .preferredColorScheme(.dark)
    }

    private var obdSnapshot: LinkStandardObdSnapshot {
        LinkStandardObdSnapshot(
            capability: model.diagnosticCapabilityText,
            capabilityDetail: model.diagnosticCapabilityDetailText,
            vin: model.vehicleVINText,
            responderSummary: model.standardResponderSummary,
            pidSummary: model.supportedPIDSummary,
            readiness: model.readinessStatusText,
            readinessMonitors: model.readinessMonitorStatus,
            freezeFrame: model.freezeFrameContext,
            storedDTCs: model.storedDTCs,
            pendingDTCs: model.pendingDTCs,
            permanentDTCs: model.permanentDTCs,
            liveRows: model.standardLiveRows)
    }

    @ViewBuilder
    private func faultGroup(_ title: String, _ values: [String]) -> some View {
        Text(title).font(.caption.bold()).foregroundStyle(ProductTheme.secondary)
        if values.isEmpty {
            Text("None reported").foregroundStyle(ProductTheme.secondary)
        } else {
            ForEach(values, id: \.self) { Text($0).font(.body.monospaced()) }
        }
    }
}
