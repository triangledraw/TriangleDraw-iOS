// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import SwiftUI

struct BrowserMenuScrollView: View {
    var body: some View {
		GeometryReader { geometry in
			ScrollView() {
				BrowserMenuView()
			}
			.frame(width: geometry.size.width)
			.background(Color.green)
		}
        .background(Color.gray)
    }
}

struct BrowserMenuScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserMenuScrollView()
    }
}
