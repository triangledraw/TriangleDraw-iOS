// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import SwiftUI
import TriangleDrawLibrary
import TTProgressHUD

enum ShareData {
    case none
    case exportPNG(image: UIImage, filename: String)
    case exportPDF(pdfData: Data, filename: String)
    case exportSVG(svgData: Data, filename: String)
}

struct HCMenuView: View {
    @ObservedObject var model: HCMenuViewModel
    @Environment(\.dismiss) var dismiss
    @State private var gridMode: CanvasGridMode
    @State private var symmetryMode: SymmetryMode
    @State private var hudVisible = false
    @State private var hudConfig = TTProgressHUDConfig(title: "Exporting")
    @State private var isSharePresented: Bool = false
    @State private var shareData: ShareData = .none

    init(model: HCMenuViewModel) {
        self.model = model
        self._gridMode = State(initialValue: model.initialGridMode)
        self._symmetryMode = State(initialValue: model.initialSymmetryMode)
    }

    var exportPNGButton: some View {
        Button("Bitmap PNG") {
            hudVisible = true
            model.exportToPNG() { status in
                switch status {
                case let HCMenuViewModel.ExportPNGStatus.ok(image, filename):
                    hudVisible = false
                    self.shareData = ShareData.exportPNG(image: image, filename: filename)
                    self.isSharePresented = true
                case HCMenuViewModel.ExportPNGStatus.progress(let progress):
                    log.debug("progress: \(progress)")
                case HCMenuViewModel.ExportPNGStatus.error(let message):
                    log.error("Unable to export to PNG. \(message)")
                    hudVisible = false
                }
            }
        }
    }

    var exportPDFButton: some View {
        Button("Vector PDF") {
            hudVisible = true
            model.exportToPDF() { status in
                switch status {
                case let HCMenuViewModel.ExportPDFStatus.ok(pdfData, filename):
                    hudVisible = false
                    self.shareData = ShareData.exportPDF(pdfData: pdfData, filename: filename)
                    self.isSharePresented = true
                case HCMenuViewModel.ExportPDFStatus.progress(let progress):
                    log.debug("progress: \(progress)")
                case HCMenuViewModel.ExportPDFStatus.error(let message):
                    log.error("Unable to export to PDF. \(message)")
                    hudVisible = false
                }
            }
        }
    }

    var exportSVGButton: some View {
        Button("Vector SVG") {
            model.exportToSVG() { status in
                switch status {
                case let HCMenuViewModel.ExportSVGStatus.ok(svgData, filename):
                    self.shareData = ShareData.exportSVG(svgData: svgData, filename: filename)
                    self.isSharePresented = true
                case HCMenuViewModel.ExportSVGStatus.error(let message):
                    log.error("Unable to export to SVG. \(message)")
                }
            }
        }
    }

    var emailDeveloperButton: some View {
        #if os(iOS)
        let view = MailButtonView(
            mailAttachmentData: nil
        )
        return AnyView(view)
        #else
        return AnyView(EmptyView())
        #endif
    }

    var navigationStack: some View {
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
                    exportPNGButton
                    exportPDFButton
                    exportSVGButton
                }
                Section(header: Text("Feedback")) {
                    emailDeveloperButton
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

    var body: some View {
        ZStack(alignment: .top) {
            navigationStack
            TTProgressHUD($hudVisible, config: hudConfig)
        }
        .sheet(isPresented: $isSharePresented, onDismiss: {
            log.debug("dismiss ActivityViewController")
            shareData = .none
        }, content: {
            ActivityViewController(shareData: $shareData)
        })
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var shareData: ShareData

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        switch shareData {
        case .none:
            log.debug("share: none")
            let activityItems = [URL(string: "http://www.triangledraw.com/")!]
            return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        case let .exportPNG(image, filename):
            log.debug("share: png")
            return HCMenuViewController.createSharePNGActivityViewController(image: image, filename: filename, triangleCount: 0)
        case let .exportPDF(pdfData, filename):
            log.debug("share: pdf")
            return HCMenuViewController.createSharePDFActivityViewController(pdfData: pdfData, filename: filename, triangleCount: 0)
        case let .exportSVG(svgData, filename):
            log.debug("share: svg")
            return HCMenuViewController.createShareSVGActivityViewController(svgData: svgData, filename: filename, triangleCount: 0)
        }
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct HCMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HCMenuView(model: HCMenuViewModel())
    }
}
