//
//  BooksDto.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import Foundation

enum BooksApi {
    enum APIError: Error {
        case invalidURL
        case noData
    }
    
    struct SearchBooksDto: Decodable {
        let kind: String
        let totalItems: Int
        let items: [SearchedBookInfo]
    }
    
    struct BookDetailDto: Decodable {
        let kind: String
        let id: String
        let etag: String
        let selfLink: String
        let volumeInfo: VoluemeInfo
        let layerInfo: LayerInfo
        let saleInfo: SaleInfo
        let accessInfo: AccessInfo
    }
}

// MARK: - Sub Types

extension BooksApi {
    struct LayerInfo: Decodable {
        let layers: [Layer]
    }
    
    struct Layer: Decodable {
        let layerId: String
        let volumeAnnotationsVersion: String
    }
    
    struct SearchedBookInfo: Decodable {
        let kind: String
        let id: String
        let etag: String
        let selfLink: String
        let volumeInfo: VoluemeInfo
        let saleInfo: SaleInfo
        let accessInfo: AccessInfo
        let searchInfo: searchInfo?
    }
    
    struct searchInfo: Decodable {
        let textSnippet: String
    }
    
    struct AccessInfo: Decodable {
        let country: String
        let viewability: String
        let embeddable: Bool
        let publicDomain: Bool
        let textToSpeechPermission: String
        let epub: Availablility
        let pdf: Availablility
        let webReaderLink: String
        let accessViewStatus: String
        let quoteSharingAllowed: Bool
    }
    
    struct VoluemeInfo: Decodable {
        let title: String
        let authors: [String]?
        let publisher: String?
        let description: String?
        let readingModes: ReadingModes
        let pageCount: Int?
        let printType: String
        let categories: [String]?
        let maturityRating: String
        let allowAnonLogging: Bool
        let contentVersion: String
        let panelizationSummary: PanelizationSummary?
        let imageLinks: ImageLinks
        let language: String
        let previewLink: String
        let infoLink: String
        let canonicalVolumeLink: String
    }
    
    struct ReadingModes: Decodable {
        let text: Bool
        let image: Bool
    }
    
    struct PanelizationSummary: Decodable {
        let containsEpubBubbles: Bool
        let containsImageBubbles: Bool
    }
    
    struct ImageLinks: Decodable {
        let smallThumbnail: String
        let thumbnail: String
        let small: String?
        let medium: String?
        let large: String?
        let extraLarge: String?
    }
    
    struct SaleInfo: Decodable {
        let country: String
        let saleability: String
        let isEbook: Bool
        let listPrice: PriceInfo?
        let retailPrice: PriceInfo?
        let buyLink: String?
        let offers: [Offer]?
    }
    
    struct Offer: Decodable {
        let finskyOfferType: Int
        let listPrice: MicroPriceInfo
        let retailPrice: MicroPriceInfo
    }
    
    struct PriceInfo: Decodable {
        let amount: Int
        let currencyCode: String
    }
    
    struct MicroPriceInfo: Decodable {
        let amountInMicros: Int
        let currencyCode: String
    }
    
    struct Availablility: Decodable {
        let isAvailable: Bool
    }
}
