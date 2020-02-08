// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import SwiftUI
import StoreKit
import MessageUI

struct BrowserMenuView: View {
	@State var result: Result<MFMailComposeResult, Error>? = nil
	@State var isShowingMailView = false

    var body: some View {
        VStack {
			Text("TriangleDraw is free software!\nYour support is appreciated.")
				.padding()
				.font(.title)
			Button(action: {
				print("Write review for App Store")
				SKStoreReviewController.requestReview()
			}) {
				Text("Write review for App Store")
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding()
					.background(Color.purple)
					.foregroundColor(.white)
					.font(.title)
			}
			Button(action: {
				print("visit twitter")
				guard let url: URL = URL(string: "https://twitter.com/TriangleDraw") else {
					return
				}
				UIApplication.shared.open(url)
			}) {
				Text("Twitter")
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding()
					.background(Color.purple)
					.foregroundColor(.white)
					.font(.title)
			}
			Button(action: {
				print("visit instagram")
				guard let url: URL = URL(string: "https://www.instagram.com/triangledraw/") else {
					return
				}
				UIApplication.shared.open(url)
			}) {
				Text("Instagram")
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding()
					.background(Color.purple)
					.foregroundColor(.white)
					.font(.title)
			}
			Button(action: {
				print("visit reddit")
				guard let url: URL = URL(string: "https://www.reddit.com/r/TriangleDraw/") else {
					return
				}
				UIApplication.shared.open(url)
			}) {
				Text("Reddit")
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding()
					.background(Color.purple)
					.foregroundColor(.white)
					.font(.title)
			}
			Button(action: {
				print("visit GitHub")
				guard let url: URL = URL(string: "https://github.com/triangledraw/TriangleDraw-iOS") else {
					return
				}
				UIApplication.shared.open(url)
			}) {
				Text("GitHub")
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding()
					.background(Color.purple)
					.foregroundColor(.white)
					.font(.title)
			}
			Button(action: {
				self.isShowingMailView.toggle()
			}) {
				Text("Email Developer")
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding()
					.background(Color.purple)
					.foregroundColor(.white)
					.font(.title)
			}
				.disabled(!MFMailComposeViewController.canSendMail())
				.sheet(isPresented: $isShowingMailView) {
					EmailWithFeedback2(result: self.$result)
				}
		}
    }
}

struct BrowserMenuView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserMenuView()
    }
}
