// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/** Audi identity and delegate binding over LINK's shared standard app model. */
@MainActor
final class ConnectionViewModel: LinkStandardProductViewModel,
    @preconcurrency AudiLinkDiagnosticsControllerDelegate {

    private let audiController: AudiLinkDiagnosticsController

    init() {
        let controller = AudiLinkDiagnosticsController()
        self.audiController = controller
        let version: String
        if let value = audilink_version() {
            version = String(cString: value)
        } else {
            version = "Unknown"
        }
        super.init(
            controller: controller,
            configuration: LinkStandardProductConfiguration(
                productName: "AUDILINK",
                productNamespace: "audilink",
                manufacturerName: "Audi",
                vehicleName: "Audi vehicle",
                versionText: version))
        controller.delegate = self
    }

    func diagnosticsControllerDidUpdate(
        _ controller: AudiLinkDiagnosticsController
    ) {
        refreshStandardState()
    }
}
