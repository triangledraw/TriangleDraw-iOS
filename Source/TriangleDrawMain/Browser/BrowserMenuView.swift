// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import SwiftUI

struct BrowserMenuView: View {
    var body: some View {
        VStack {
			Text("TriangleDraw is free software!\nYour support is appreciated.")
				.padding()
				.font(.title)
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
		}
    }
}

struct BrowserMenuView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserMenuView()
    }
}
