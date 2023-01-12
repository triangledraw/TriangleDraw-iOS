// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI
import TriangleDrawLibrary

struct HCMenuView: View {
    @ObservedObject var model: HCMenuViewModel
    @Environment(\.dismiss) var dismiss
    @State private var gridMode: CanvasGridMode
    @State private var symmetryMode: SymmetryMode

    init(model: HCMenuViewModel, symmetryMode: SymmetryMode) {
        self.model = model
        self._gridMode = State(initialValue: model.initialGridMode)
        self._symmetryMode = State(initialValue: symmetryMode)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Grid system")) {
                    Picker("Format", selection: $gridMode) {
                        ForEach(CanvasGridMode.allCases, id: \.self) { value in
                            Text(value.localizedDisplayName).tag(value)
                        }
                    }.onChange(of: gridMode) { newValue in
                        self.model.delegate?.hcMenuViewController_canvasGridModeDidChange(gridMode: newValue)
                    }
                    Picker("Symmetry", selection: $symmetryMode) {
                        ForEach(SymmetryMode.allCases, id: \.self) { value in
                            Text(value.localizedDisplayName).tag(value)
                        }
                    }.onChange(of: symmetryMode) { newValue in
                        globalSymmetryMode = newValue
                    }
                    NavigationLink("Subdivide") {
                        HCMenuSubdivideView() { n in
                            model.delegate?.hcMenuViewController_applySubdivide(n: n)
                            dismiss()
                        }
                    }
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
        HCMenuView(model: HCMenuViewModel(), symmetryMode: .noSymmetry)
    }
}
