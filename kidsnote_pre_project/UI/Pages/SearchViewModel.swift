//
//  SearchViewModel.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    // MARK: - Types
    
    struct BookInfo: Identifiable {
        var id = UUID()
        let thumbnailUrl: String
        let authors: [String]
        let title: String
        let type: String
    }
    
    enum BookType {
        case ebook
        case all
    }
    
    struct StateData {
        var ebooks: [BookInfo] = []
        var currentTab: BookType = .ebook
        var allListLoaded = false
        var hasSearchHistory = false
    }
    
    actor SearchedList {
        private var searchedEBooks: [String : [BookInfo]] = [:]
        private var searchedAllBooks: [String : [BookInfo]] = [:]
        
        func startIndex(state: StateData, searchText: String) -> Int {
            var startIndex = 0
            if state.currentTab == .ebook {
                startIndex = searchedEBooks[searchText]?.count ?? 0
            } else {
                startIndex = searchedAllBooks[searchText]?.count ?? 0
            }
            return startIndex
        }
        
        func update(state: StateData, searchText: String, totalItems: Int, items: [BooksApi.SearchedBookInfo]) -> StateData {
            var updateStage = state
            let tabType = updateStage.currentTab
            let books = items.map { info in
                BookInfo(
                    thumbnailUrl: info.volumeInfo.imageLinks.thumbnail,
                    authors: info.volumeInfo.authors ?? [],
                    title: info.volumeInfo.title,
                    type: (tabType == .ebook) ? "eBook" : "Book"
                )
            }
            updateStage.hasSearchHistory = true
            let allBooks = updateStage.ebooks + books
            if updateStage.currentTab == .ebook {
                searchedEBooks[searchText] = allBooks
            } else {
                searchedAllBooks[searchText] = allBooks
            }
            updateStage.ebooks = allBooks
            updateStage.allListLoaded = allBooks.count >= totalItems
            return updateStage
        }
        
        func clear(state: StateData) -> StateData {
            var updateStage = state
            updateStage.ebooks = []
            updateStage.allListLoaded = false
            updateStage.hasSearchHistory = false
            updateStage.currentTab = .ebook
            return updateStage
        }
        
        func reset(state: StateData) -> StateData {
            var updateStage = state
            updateStage.ebooks = []
            updateStage.allListLoaded = false
            return updateStage
        }
    }
    
    // MARK: - Public
    
    @Published var ebooks: [BookInfo] = []
    @Published var currentTab: BookType = .ebook
    @Published var allListLoaded = false
    @Published var hasSearchHistory = false
    @Published var stateData: StateData
    
    let searchbarViewModel: SearchBarViewModel
    let listData: SearchedList
    let loadMoreSearchedList = PassthroughSubject<String, Never>()
    let clearList = PassthroughSubject<Void, Never>()
    
    // MARK: - Private
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        stateData = StateData()
        listData = SearchedList()
        searchbarViewModel = SearchBarViewModel()
        bind()
    }
}

// MARK: - Private

extension SearchViewModel {
    private func bind() {
        searchbarViewModel.searchButtonPressed
            .merge(with: loadMoreSearchedList)
            .flatMap { searchText in
                Deferred {
                    Future<(BooksApi.SearchBooksDto, String), Never> { promise in
                        Task { @MainActor [weak self] in
                            guard let self else {
                                return promise(.success((BooksApi.SearchBooksDto(kind: "", totalItems: 0, items: []), searchText)))
                            }
                            let startIndex = await listData.startIndex(state: stateData, searchText: searchText)
                            return requstSearch(searchText: searchText, startIndex: startIndex, isEbook: stateData.currentTab == .ebook)
                                .replaceError(with: BooksApi.SearchBooksDto(kind: "error", totalItems: 0, items: []))
                                .map {
                                    ($0, searchText)
                                }
                                .sink { result in
                                    promise(.success(result))
                                }
                                .store(in: &cancellableSet)
                        }
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { result in
                let searchText = result.1
                let response = result.0
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await stateData = listData.update(
                        state: stateData,
                        searchText: searchText,
                        totalItems: response.totalItems,
                        items: response.items
                    )
                }
            }
            .store(in: &cancellableSet)
        
        // reset case
        searchbarViewModel.searchButtonPressed
            .sink { _ in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    stateData = await listData.reset(state: stateData)
                }
            }
            .store(in: &cancellableSet)
        
        clearList
            .sink {
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    stateData = await listData.clear(state: stateData)
                }
            }
            .store(in: &cancellableSet)
    }
    
    private func requstSearch(searchText: String, startIndex: Int, isEbook: Bool) -> AnyPublisher<BooksApi.SearchBooksDto, Error> {
        Deferred {
            Future<BooksApi.SearchBooksDto, Error> { promise in
                Task {
                    do {
                        let searchedBooks = try await BooksApi.searchBooks(query: searchText, startIndex: startIndex, isEbook: isEbook)
                        promise(.success(searchedBooks))
                    } catch {
                        Logger.log("error = \(error)")
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Public

extension SearchViewModel {
    func search(_ searchText: String) {
        searchbarViewModel.searchButtonPressed.send(searchText)
    }
}

// MARK: - Preview

extension SearchViewModel {
    func asHasSerchedBooks() -> Self {
        stateData.ebooks = [
            SearchViewModel.BookInfo(thumbnailUrl: "http://books.google.com/books/content?id=TnSCCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api", authors: ["자청"], title: "역행자", type: "eBook"),
            SearchViewModel.BookInfo(thumbnailUrl: "http://books.google.com/books/content?id=TnSCCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api", authors: ["자청"], title: "역행자", type: "eBook"),
            SearchViewModel.BookInfo(thumbnailUrl: "http://books.google.com/books/content?id=TnSCCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api", authors: ["자청"], title: "역행자", type: "eBook"),
            SearchViewModel.BookInfo(thumbnailUrl: "http://books.google.com/books/content?id=TnSCCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api", authors: ["자청"], title: "역행자", type: "eBook"),
            SearchViewModel.BookInfo(thumbnailUrl: "http://books.google.com/books/content?id=TnSCCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api", authors: ["자청"], title: "역행자", type: "eBook")
        ]
        return self
    }
}
