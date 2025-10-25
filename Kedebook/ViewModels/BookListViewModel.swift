//
//  BookListViewModel.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class BookListViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = BookService()

    func search() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await service.searchBooks(query: query)
            self.books = results
        } catch {
            self.errorMessage = error.localizedDescription
            self.books = []
        }
        isLoading = false
    }
}
