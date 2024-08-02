//
//  BooksDto.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import Foundation

public enum BooksApi {
    public enum APIError: Error {
        case invalidURL
        case noData
    }
    
    public struct SearchBooksDto: Decodable {
        public let kind: String
        public let totalItems: Int
        public let items: [SearchedBookInfo]
        
        public init(kind: String, totalItems: Int, items: [SearchedBookInfo]) {
            self.kind = kind
            self.totalItems = totalItems
            self.items = items
        }
    }
}

// MARK: - Sub Types

public extension BooksApi {
    struct LayerInfo: Decodable {
        public let layers: [Layer]
    }
    
    struct Layer: Decodable {
        public let layerId: String
        public let volumeAnnotationsVersion: String
    }
    
    struct SearchedBookInfo: Decodable {
        public let kind: String
        public let id: String
        public let etag: String
        public let selfLink: String
        public let volumeInfo: VoluemeInfo
        public let saleInfo: SaleInfo
        public let accessInfo: AccessInfo
        public let searchInfo: searchInfo?
    }
    
    struct searchInfo: Decodable {
        public let textSnippet: String
    }
    
    struct AccessInfo: Decodable {
        public let country: String
        public let viewability: String
        public let embeddable: Bool
        public let publicDomain: Bool
        public let textToSpeechPermission: String
        public let epub: Availablility
        public let pdf: Availablility
        public let webReaderLink: String
        public let accessViewStatus: String
        public let quoteSharingAllowed: Bool
    }
    
    struct VoluemeInfo: Decodable {
        public let title: String
        public let authors: [String]?
        public let publisher: String?
        public let publishedDate: String
        public let description: String?
        public let readingModes: ReadingModes
        public let pageCount: Int?
        public let printType: String
        public let categories: [String]?
        public let maturityRating: String
        public let allowAnonLogging: Bool
        public let contentVersion: String
        public let panelizationSummary: PanelizationSummary?
        public let imageLinks: ImageLinks
        public let language: String
        public let previewLink: String
        public let infoLink: String
        public let canonicalVolumeLink: String
        public let averageRating: Double?
        public let ratingsCount: Int?
    }
    
    struct ReadingModes: Decodable {
        public let text: Bool
        public let image: Bool
    }
    
    struct PanelizationSummary: Decodable {
        public let containsEpubBubbles: Bool
        public let containsImageBubbles: Bool
    }
    
    struct ImageLinks: Decodable {
        public let smallThumbnail: String
        public let thumbnail: String
        public let small: String?
        public let medium: String?
        public let large: String?
        public let extraLarge: String?
    }
    
    struct SaleInfo: Decodable {
        public let country: String
        public let saleability: String
        public let isEbook: Bool
        public let listPrice: PriceInfo?
        public let retailPrice: PriceInfo?
        public let buyLink: String?
        public let offers: [Offer]?
    }
    
    struct Offer: Decodable {
        public let finskyOfferType: Int
        public let listPrice: MicroPriceInfo
        public let retailPrice: MicroPriceInfo
    }
    
    struct PriceInfo: Decodable {
        public let amount: Int
        public let currencyCode: String
    }
    
    struct MicroPriceInfo: Decodable {
        public let amountInMicros: Int
        public let currencyCode: String
    }
    
    struct Availablility: Decodable {
        public let isAvailable: Bool
    }
}
