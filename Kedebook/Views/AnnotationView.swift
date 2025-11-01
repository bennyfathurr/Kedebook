//
//  AnnotationView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 29/10/25.
//

import SwiftUI
import VisionKit
import SwiftData

@available(iOS 16.0, *)
struct AnnotationView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AnnotationViewModel()
    @State private var showScanner = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Annotation") {
                    TextEditor(text: $viewModel.annotationText)
                        .frame(minHeight: 150)
                        .scrollContentBackground(.hidden)
                        .background(Color(UIColor.systemBackground))
                        .overlay(
                            Group {
                                if viewModel.annotationText.isEmpty {
                                    Text("Scan text or write your own annotation...")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }
                            }, alignment: .topLeading
                        )
                }

                Section {
                    Button {
                        showScanner = true
                    } label: {
                        Label("Scan Book", systemImage: "camera.viewfinder")
                    }
                    .disabled(!DataScannerViewController.isSupported)

                    Button {
                        viewModel.isSpeaking ? viewModel.stopSpeaking() : viewModel.speak()
                    } label: {
                        Label(viewModel.isSpeaking ? "Stop Reading" : "Listen", systemImage: viewModel.isSpeaking ? "stop.circle.fill" : "speaker.wave.2.fill")
                    }
                    .disabled(viewModel.annotationText.isEmpty)
                }

                Section {
                    Button(role: .none) {
                        viewModel.saveAnnotation(context: context)
                        viewModel.annotationText = ""
                    } label: {
                        Label("Save Annotation", systemImage: "tray.and.arrow.down")
                    }
                    .disabled(viewModel.annotationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Annotation")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showScanner) {
                if #available(iOS 16.0, *) {
                    ScannerView(viewModel: viewModel)
                }
            }
        }
    }
}
