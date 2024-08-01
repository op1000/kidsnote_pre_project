//
//  ImageView.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: ImageViewModel
    @State var image: Image
    init(viewModel: ImageViewModel, image: Image) {
        self.viewModel = viewModel
        self.image = image
    }
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    ImageView(viewModel: ImageViewModel(urlString: "http://books.google.com/books/content?id=7N0sEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")
    , image: Image(systemName: "door.garage.double.bay.closed"))
    .frame(width: 100, height: 100)
}
