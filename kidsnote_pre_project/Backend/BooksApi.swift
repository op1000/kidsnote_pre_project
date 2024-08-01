//
//  BooksApi.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import Foundation
import Combine

extension BooksApi {
    private enum Constants {
        static let apiKey = "AIzaSyAa56DbQo3xnGqrkLHeklbX1mOL0UddKgk"
        static let baseURL = "https://www.googleapis.com"
        static let searchEbook = "/books/v1/volumes?q=%@&startIndex=%@&maxResults=10&filter=ebooks&key=%@"
        static let searchAll = "/books/v1/volumes?q=%@&startIndex=%@&maxResults=10&key=%@"
        static let detail = "/books/v1/volumes/%@?key=%@"
    }
    
    static func searchBooks(query: String, startIndex: Int, isEbook: Bool) async throws -> SearchBooksDto {
        let urlFormat = Constants.baseURL + (isEbook ? Constants.searchEbook : Constants.searchAll)
        guard let urlString = String(format: urlFormat, query.trimmingCharacters(in: .whitespacesAndNewlines), "\(startIndex)", Constants.apiKey).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIError.invalidURL
        }
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        BooksApi.logResponseString(data: data)
        
        let result = try JSONDecoder().decode(SearchBooksDto.self, from: data)
        return result
    }
}

// MARK: - debugging

extension BooksApi {
    private static func logResponseString(data: Data) {
        if let str = String(data: data, encoding: .utf8) {
            Logger.log("Successfully decoded: \(str)")
        }
    }
}

