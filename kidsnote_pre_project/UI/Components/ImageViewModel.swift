//
//  ImageViewModel.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    let urlString: String
    @Published var image: Image?

    init(urlString: String) {
        self.urlString = urlString
        load()
    }
}

// MARK: - Public

extension ImageViewModel {
    func load() {
        guard let url = URL(string: urlString) else { return }
        Task {
            let (imageData, _) = try await URLSession.shared.data(from: url)
            Task { @MainActor [weak self] in
                guard let self else { return }
                guard let uiimage = UIImage(data: imageData) else { return }
                image = Image(uiImage: uiimage)
            }
        }
    }
}
