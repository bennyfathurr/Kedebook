//
//  SupabaseClientManager.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Supabase
import Foundation

struct SupabaseClientManager {
    static let shared = SupabaseClientManager()
    let client: SupabaseClient

    private init() {
        client = SupabaseClient(supabaseURL: URL(string: "https://ikyapjjkrhbfaagflquw.supabase.co")!,
                                supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlreWFwamprcmhiZmFhZ2ZscXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEzNzA5MzgsImV4cCI6MjA3Njk0NjkzOH0.dhy6A8Kzg_gM77bbQkpA4zXRYulthHGV83wuc-Dmetc")
    }
}

