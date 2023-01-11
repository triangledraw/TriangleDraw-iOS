// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI
import MessageUI

struct MailButtonView: View {
    let mailAttachmentData: Data?
    @State var result: Result<MFMailComposeResult, Error>?
    @State var isShowingMailView = false

    var body: some View {
        Button(action: {
            self.isShowingMailView.toggle()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) {
            Text("Email Developer")
        }
        .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            MailView(
                result: self.$result,
                mailAttachmentData: self.mailAttachmentData
            )
        }
    }
}

struct MailButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MailButtonView(
            mailAttachmentData: nil
        )
    }
}
