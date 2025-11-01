//
//  LibraryView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI
import SwiftData
import Combine

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [UserProfile]

    @StateObject private var viewModel = BookListViewModel()
    @State private var selectedCategory: String = "All"
    @State private var showProfile = false
    @State private var featuredBook: Book?
    @State private var timerCancellable: AnyCancellable?

    private let categories = ["All", "Psychology", "Comedy", "Nature", "Sci-Fi", "Business"]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                    .padding(.bottom, 8)

                if let featuredBook {
                    featuredSection(for: featuredBook)
                }

                categoryChips
                bookGrid
            }
            .task { await loadBooks() }
            .onAppear {
                startFeaturedTimer()
            }
            .onDisappear {
                timerCancellable?.cancel()
            }
        }
        .background(KdColor.background.ignoresSafeArea())
        .sheet(isPresented: $showProfile) {
            NavigationStack { ProfileView() }
                .presentationDetents([.large])
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack(spacing: 14) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showProfile = true
                }
            } label: {
                if let profile = profiles.first,
                   let path = profile.avatarPath,
                   let image = UIImage(contentsOfFile: path) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 52)
                        .clipShape(Circle())
                        .shadow(radius: 1.5)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                        .foregroundStyle(KdColor.iconInactive)
                        .shadow(radius: 1.5)
                }
            }
            .buttonStyle(.plain)
            .scaleEffect(showProfile ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showProfile)

            VStack(alignment: .leading, spacing: 2) {
                Text(greetingMessage())
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.textTritary)

                Text(profiles.first?.name ?? "Reader 👋")
                    .font(.subheadline)
                    .foregroundStyle(Color.textTritary)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 3..<12: return "🌤️ Good morning,"
        case 12..<17: return "☀️ Good afternoon,"
        case 17..<22: return "🌥️ Good evening,"
        default: return "🌕 Good night,"
        }
    }

    // MARK: - Featured
    private func featuredSection(for book: Book) -> some View {
        let rating = viewModel.averageRating(for: book.id)
        return NavigationLink(destination: BookDetailView(book: book)) {
            FeaturedBookCard(
                coverURL: book.coverURL(size: .large),
                title: book.title,
                author: book.author_name?.first ?? "",
                rating: rating
            )
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Categories
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: KdSpace.sm) {
                ForEach(categories, id: \.self) { cat in
                    KdChip(
                        title: cat,
                        isSelected: selectedCategory == cat
                    ) {
                        selectedCategory = cat
                        Task { await loadBooks() }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, KdSpace.md)
        }
    }

    // MARK: - Books Grid
    private var bookGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 22), GridItem(.flexible(), spacing: 22)],
            spacing: 28
        ) {
            ForEach(viewModel.books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    BookCard(
                        coverURL: book.coverURL(size: .medium),
                        title: book.title,
                        author: book.author_name?.first ?? ""
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 80)
    }

    // MARK: - Data
    private func loadBooks() async {
        do {
            let fetched = try await BookService().fetchBooks(for: selectedCategory)
            await MainActor.run {
                viewModel.books = fetched
                featuredBook = fetched.randomElement()
            }
        } catch {
            print("Book fetch failed:", error)
        }
    }

    private func startFeaturedTimer() {
        timerCancellable = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if !viewModel.books.isEmpty {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        featuredBook = viewModel.books.randomElement()
                    }
                }
            }
    }
}
