//
//  DetailViewModel.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 8/1/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    // MARK: - Public
    
    let freeSampleButtonPressed = PassthroughSubject<Void, Never>()
    let buyButtonPressed = PassthroughSubject<Void, Never>()
    @Published var loadWebUrl: String?
    
    // MARK: - Private
    
    private(set) var bookInfo: SearchViewModel.BookInfo
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(info: SearchViewModel.BookInfo) {
        Logger.log("requst detail init")
        self.bookInfo = info
        bind()
    }
}

// MARK: - Private

extension DetailViewModel {
    private func bind() {
        freeSampleButtonPressed
            .sink { [weak self] in
                guard let self else { return }
                Logger.log("freeSampleButtonPressed")
                loadWebUrl = bookInfo.previewLink
            }
            .store(in: &cancellableSet)
        
        buyButtonPressed
            .sink { [weak self] in
                guard let self else { return }
                Logger.log("freeSampleButtonPressed")
                loadWebUrl = bookInfo.buyLink
            }
            .store(in: &cancellableSet)
    }
}
