//
//  APIClient.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 23/10/25.
//

import Foundation

enum APIClient: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

class APIClient {
    
}
