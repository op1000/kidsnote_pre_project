//
//  SafariView.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 8/1/24.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var urlString: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let urlToLoad = URL(string: urlString) else {
            return SFSafariViewController(url: URL(string: "about:blank")!)
        }
        return SFSafariViewController(url: urlToLoad)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

