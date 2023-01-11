// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI
import TriangleDrawLibrary

struct HCMenuView: View {
    @ObservedObject var model: HCMenuViewModel
    @Environment(\.dismiss) var dismiss
    @State private var gridMode: CanvasGridMode = CanvasGridMode.smallFixedSizeDots
    @State private var symmetryMode: SymmetryMode = SymmetryMode.noSymmetry

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Grid system")) {
                    Picker("Format", selection: $gridMode) {
                        ForEach(CanvasGridMode.allCases, id: \.self) { value in
                            Text(value.localizedDisplayName).tag(value)
                        }
                    }
                    Picker("Symmetry", selection: $symmetryMode) {
                        ForEach(SymmetryMode.allCases, id: \.self) { value in
                            Text(value.localizedDisplayName).tag(value)
                        }
                    }
                    Button("Subdivide") {}
                }
                Section(header: Text("Export")) {
                    Button("Bitmap PNG") {}
                    Button("Vector PDF") {}
                    Button("Vector SVG") {}
                }
                Section(header: Text("Feedback")) {
                    Button("Email Developer") {}
                }
            }
            .navigationTitle("Canvas")
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

struct HCMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HCMenuView(model: HCMenuViewModel())
    }
}
