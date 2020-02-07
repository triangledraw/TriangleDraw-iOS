// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import SwiftUI

struct BrowserMenuNavigationView: View {
    var dismissAction: (() -> Void)?

	var body: some View {
        NavigationView {
			BrowserMenuView()
				.navigationBarItems(leading:
					Button(action: {
						self.dismissAction?()
					}, label: {
						Text("OK")
					})
				)
				.navigationBarTitle("TriangleDraw")
		}
	}
}

struct BrowserMenuNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserMenuNavigationView()
    }
}
