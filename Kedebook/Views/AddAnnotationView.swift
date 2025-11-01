//
//  AddAnnotationView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 28/10/25.
//

import SwiftUI
import SwiftData

struct AddAnnotationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var page: String = ""
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Page")) {
                    TextField("e.g. 45", text: $page)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Note")) {
                    TextEditor(text: $note)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Add Annotation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAnnotation()
                    }
                    .disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveAnnotation() {
        let newAnnotation = BookAnnotation(page: page, note: note, date: Date())
        context.insert(newAnnotation)
        try? context.save()
        dismiss()
    }
}
