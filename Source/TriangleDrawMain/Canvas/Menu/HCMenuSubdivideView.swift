// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI

struct HCMenuSubdivideView: View {
    @State private var divisionSize: UInt = 2

    var body: some View {
        Form {
            Text("Split up all triangles into smaller triangles")
            Picker("Divisions", selection: $divisionSize) {
                Text("2").tag(2)
                Text("3").tag(3)
                Text("4").tag(4)
                Text("5").tag(5)
                Text("6").tag(6)
                Text("7").tag(7)
            }.pickerStyle(.wheel)
            Button("Apply") {}
        }
    }
}

struct HCMenuSubdivideView_Previews: PreviewProvider {
    static var previews: some View {
        HCMenuSubdivideView()
    }
}
