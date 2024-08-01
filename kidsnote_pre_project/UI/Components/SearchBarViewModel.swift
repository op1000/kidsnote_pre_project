//
//  SearchBarViewModel.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import Foundation
import Combine

class SearchBarViewModel: ObservableObject {
    let searchButtonPressed = PassthroughSubject<String, Never>()
    
    init() {
        bind()
    }
}

// MARK: - Private

extension SearchBarViewModel {
    private func bind() {
        
    }
}
