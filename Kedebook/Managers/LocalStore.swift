//
//  LocalStore.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftData
import Foundation

@MainActor
final class LocalStore {
    static let shared = LocalStore()
    let container: ModelContainer

    private init() {
        container = try! ModelContainer(for: ReviewEntity.self)
    }

    func save(_ review: ReviewEntity) {
        let ctx = container.mainContext
        ctx.insert(review)
        try? ctx.save()
    }

    func pendingReviews() -> [ReviewEntity] {
        let ctx = container.mainContext
        let desc = FetchDescriptor<ReviewEntity>(predicate: #Predicate { !$0.synced })
        return (try? ctx.fetch(desc)) ?? []
    }

    func markSynced(_ id: UUID) {
        let ctx = container.mainContext
        if let obj = try? ctx.fetch(FetchDescriptor<ReviewEntity>(predicate: #Predicate { $0.localID == id })).first {
            obj.synced = true
            try? ctx.save()
        }
    }
}


