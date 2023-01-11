// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI
import StoreKit

struct BrowserMenu2View: View {
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

    func emailDeveloperAction() {
        print("TODO: td_presentEmailWithFeedback open MFMailComposeViewController from SwiftUI")
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
                    Button(
                        "Email Developer",
                        action: emailDeveloperAction
                    )
                }
                Section(header: Text("App info")) {
                    Text("Version x.y.z")
                    Text("Creation Date x")
                    Text("Run Count x")
                }
            }
            .navigationTitle("TriangleDraw")
        }
    }
}

struct BrowserMenu2View_Previews: PreviewProvider {
    static var previews: some View {
        BrowserMenu2View()
    }
}
