// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI

struct HCMenuSubdivideView: View {
    let applySubdivide: (_ n: UInt8) -> Void
    @State private var divisionSize: UInt8 = 2
    let pickerValues: [UInt8] = [2, 3, 4, 5, 6, 7]

    var body: some View {
        Form {
            Section() {
                HStack {
                    Spacer()
                    Text("Split up all triangles\ninto smaller triangles")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                    Spacer()
                }
            }
            Section() {
                Text("Select number of divisions")

                Picker("Subdivide", selection: $divisionSize) {
                    ForEach(pickerValues, id: \.self) { i in
                        Text(String(i))
                    }
                }
                .id(pickerValues)
                .pickerStyle(.wheel)

                Button("Apply") {
                    self.applySubdivide(divisionSize)
                }
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Subdivide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HCMenuSubdivideView_Previews: PreviewProvider {
    static var previews: some View {
        HCMenuSubdivideView() { _ in }
    }
}
