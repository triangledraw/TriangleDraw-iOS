// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import SwiftUI
import StoreKit
import MessageUI


struct MyButtonStyle: ButtonStyle {
    var color: Color = .purple

    public func makeBody(configuration: MyButtonStyle.Configuration) -> some View {
        configuration.label
//			.frame(minWidth: 0, maxWidth: .infinity)
			.padding()
			.font(.title)
			.background(color)
			.foregroundColor(.white)
			.opacity(configuration.isPressed ? 0.5 : 1.0)
			.cornerRadius(5)
			.padding(10)
//			.border(Color.green, width: 5)
//			.cornerRadius(10)
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.purple, lineWidth: 5)
		)
    }
}

struct Box: Identifiable {
	let id: Int
	let title: String
	let url: URL
}

struct BrowserMenuView: View {
	@State var result: Result<MFMailComposeResult, Error>? = nil
	@State var isShowingMailView = false

	let boxes: [Box] = [
		Box(id: 0, title: "Twitter", url: URL(string: "https://twitter.com/TriangleDraw")!),
		Box(id: 1, title: "Instagram", url: URL(string: "https://www.instagram.com/triangledraw/")!),
		Box(id: 2, title: "Reddit", url: URL(string: "https://www.reddit.com/r/TriangleDraw/")!)
	]

    var body0: some View {
		List {
//			VStack {
//				Text("TriangleDraw is free software!")
//					.font(.title)
//				Text("Your support is appreciated.")
//	                .font(.subheadline)
//			}
//				.frame(maxWidth: .infinity, alignment: .center)
//			.listRowInsets(EdgeInsets())
//
//			Text("WEB")
//				.frame(maxWidth: .infinity, alignment: .leading)
//				.listRowInsets(EdgeInsets())

			ForEach(self.boxes) { box in
				Text(box.title)
			}
				.listRowInsets(EdgeInsets())
//				.listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
//			Section(header: Text("DEVELOPMENT")) {
//                BrowserMenuRow()
//                BrowserMenuRow()
//                BrowserMenuRow()
//            }
//			Section(header: Text("APP")) {
//                BrowserMenuRow()
//                BrowserMenuRow()
//                BrowserMenuRow()
//            }
		}
		.onAppear {
			UITableView.appearance().separatorStyle = .none
		}
		.onDisappear {
			UITableView.appearance().separatorStyle = .singleLine
		}
//		.listStyle(GroupedListStyle())
	}

    var body1: some View {
		List {
			Text("lsdkjf")
			Section(header: Text("WEB")) {
				ForEach(self.boxes) { box in
					Text(box.title)
				}
            }
			Section(header: Text("DEVELOPMENT")) {
                BrowserMenuRow()
                BrowserMenuRow()
                BrowserMenuRow()
            }
			Section(header: Text("APP")) {
                BrowserMenuRow()
                BrowserMenuRow()
                BrowserMenuRow()
            }
		}
		.listStyle(GroupedListStyle())
	}

	var body: some View {
        VStack {
			Text("TriangleDraw is free software!\nYour support is appreciated.")
				.padding()
				.font(.title)

            Spacer()

			Button("Write review for App Store") {
				print("Write review for App Store")
				SKStoreReviewController.requestReview()
            }.buttonStyle(MyButtonStyle())

			Button("Twitter") {
				print("visit twitter")
				guard let url: URL = URL(string: "https://twitter.com/TriangleDraw") else {
					return
				}
				UIApplication.shared.open(url)
			}.buttonStyle(MyButtonStyle())

			Button("Instagram") {
				print("visit instagram")
				guard let url: URL = URL(string: "https://www.instagram.com/triangledraw/") else {
					return
				}
				UIApplication.shared.open(url)
			}.buttonStyle(MyButtonStyle())

			Button("Reddit") {
				print("visit reddit")
				guard let url: URL = URL(string: "https://www.reddit.com/r/TriangleDraw/") else {
					return
				}
				UIApplication.shared.open(url)
			}.buttonStyle(MyButtonStyle())

            Spacer()

			Button("GitHub") {
				print("visit GitHub")
				guard let url: URL = URL(string: "https://github.com/triangledraw/TriangleDraw-iOS") else {
					return
				}
				UIApplication.shared.open(url)
			}.buttonStyle(MyButtonStyle())

			Button("Email Developer") {
				self.isShowingMailView.toggle()
			}
				.buttonStyle(MyButtonStyle())
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
