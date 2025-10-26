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
    private init() {}

    func save(_ review: ReviewEntity,context: ModelContext) {
        context.insert(review)
        try? context.save()
    }

    func pendingReviews(context: ModelContext) -> [ReviewEntity] {
        let desc = FetchDescriptor<ReviewEntity>(predicate: #Predicate { !$0.synced })
        return (try? context.fetch(desc)) ?? []
    }

    func markSynced(_ id: UUID, context: ModelContext) {
            let d = FetchDescriptor<ReviewEntity>(predicate: #Predicate { $0.localID == id })
            if let obj = try? context.fetch(d).first {
                obj.synced = true
                try? context.save()
            }
        }
}


