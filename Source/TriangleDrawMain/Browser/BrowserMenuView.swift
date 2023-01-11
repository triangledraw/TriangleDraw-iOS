// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI
import StoreKit

struct BrowserMenuView: View {
    @ObservedObject var model: BrowserMenuViewModel
    @Environment(\.dismiss) var dismiss

    func appStoreWriteReviewAction() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    func githubTriangleDrawRepositoryAction() {
        guard let url: URL = URL(string: "https://github.com/triangledraw/TriangleDraw-iOS") else {
            print("Unable to create url. Cannot open browser.")
            return
        }
        UIApplication.shared.open(url)
    }

    func githubTriangleDrawGalleryAction() {
        guard let url: URL = URL(string: "https://github.com/triangledraw/TriangleDraw-Gallery") else {
            print("Unable to create url. Cannot open browser.")
            return
        }
        UIApplication.shared.open(url)
    }

    var emailDeveloperButton: some View {
        #if os(iOS)
        let view = MailButtonView(
            mailAttachmentData: nil
        )
        return AnyView(view)
        #else
        return AnyView(EmptyView())
        #endif
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Help needed")) {
                    Button(
                        "Write review for App Store",
                        action: appStoreWriteReviewAction
                    )
                }
                Section(header: Text("Development")) {
                    Button(
                        "GitHub - TriangleDraw-iOS",
                        action: githubTriangleDrawRepositoryAction
                    )
                    Button(
                        "GitHub - TriangleDraw-Gallery",
                        action: githubTriangleDrawGalleryAction
                    )
                    emailDeveloperButton
                }
                Section(header: Text("App info")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(self.model.appVersion)
                    }
                    HStack {
                        Text("Creation Date")
                        Spacer()
                        Text(self.model.appCreationDateString)
                    }
                    HStack {
                        Text("Run Count")
                        Spacer()
                        Text(self.model.appRunCount)
                    }
                }
            }
            .navigationTitle("TriangleDraw")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct BrowserMenu2View_Previews: PreviewProvider {
    static var previews: some View {
        BrowserMenuView(model: BrowserMenuViewModel())
    }
}
