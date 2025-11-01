//
//  ScannerView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 29/10/25.
//

import SwiftUI
import VisionKit

@available(iOS 16.0, *)
struct ScannerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: AnnotationViewModel

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            isHighlightingEnabled: true
        )
        viewController.delegate = context.coordinator
        try? viewController.startScanning()
        return viewController
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var viewModel: AnnotationViewModel

        init(viewModel: AnnotationViewModel) {
            self.viewModel = viewModel
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            guard case .text(let text) = item else { return }
            viewModel.appendScannedText(text.transcript)
        }

        func dataScannerDidBecomeUnavailable(_ dataScanner: DataScannerViewController) {
            print("Scanner unavailable")
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didEncounterError error: Error) {
            print("Scanner error:", error.localizedDescription)
        }
    }
}
