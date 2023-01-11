// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    let mailAttachmentData: Data?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            presentation: presentation,
            result: $result
        )
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let infoToDeveloper: String = SystemInfo.systemInfo

        var items = [String]()
        items.append("What do you think?")
        items.append("")
        items.append("")
        items.append("Helpful info for the developer:")
        items.append(infoToDeveloper)
        let messageBody: String = items.joined(separator: "\n")

        let subject = "Help improve TriangleDraw"
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(subject)
        vc.setToRecipients(["TriangleDraw <hello@triangledraw.com>"])
        vc.setMessageBody(messageBody, isHTML: false)
        if Platform.is_ideom_ipad {
            vc.modalPresentationStyle = .pageSheet
        }
        if let data = mailAttachmentData {
            vc.addAttachmentData(data, mimeType: "application/octet-stream", fileName: "triangledraw.txt")
        }
        return vc
    }

    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>) {
    }
}
