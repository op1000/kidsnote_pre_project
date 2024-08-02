//
//  SearchView.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SearchViewModel
    @State private var searchText = ""
    @Binding var redrawId: UUID
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .frame(width: 35, height: 35)
                        .foregroundColor(.gray)
                }
                SearchBar(viewModel: viewModel.searchbarViewModel, text: $searchText)
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            if viewModel.stateData.ebooks.isEmpty, !viewModel.stateData.hasSearchHistory {
                Spacer()
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    TabBar(viewModel: viewModel, searchText: $searchText)
                        .padding(.top, 20)
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            Text("Google Play 검색결과")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                            ForEach(viewModel.stateData.ebooks) { book in
                                NavigationLink {
                                    DetailView(viewModel: DetailViewModel(info: book))
                                        .id(book.id)
                                } label: {
                                    BookRow(viewModel: viewModel, info: book)
                                }
                            }
                            if !viewModel.stateData.allListLoaded {
                                HStack(spacing: 0) {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .onAppear {
                                    viewModel.loadMoreSearchedList.send(searchText)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: searchText) { text in
            if text.isEmpty {
                viewModel.clearList.send()
            }
        }
        .refreshable {
            viewModel.search(searchText)
        }
        .navigationBarBackButtonHidden(true)
        .id(redrawId)
    }
}

private struct TabBar: View {
    @ObservedObject var viewModel: SearchViewModel
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 0) {
                Spacer()
                Button {
                    viewModel.currentTab = .ebook
                    viewModel.searchbarViewModel.searchButtonPressed.send(searchText)
                } label: {
                    VStack(spacing: 2) {
                        Text("eBook")
                            .font(.body)
                            .bold(viewModel.currentTab == .ebook)
                            .foregroundColor(.blue)
                        Rectangle()
                            .frame(height: 2)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 2,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 2
                                )
                            )
                            .opacity(viewModel.currentTab == .ebook ? 1 : 0)
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
                Spacer()
                Button {
                    viewModel.currentTab = .all
                    viewModel.searchbarViewModel.searchButtonPressed.send(searchText)
                } label: {
                    VStack(spacing: 2) {
                        Text("All")
                            .font(.body)
                            .bold(viewModel.currentTab == .all)
                            .foregroundColor(.blue)
                        Rectangle()
                            .frame(height: 2)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 2,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 2
                                )
                            )
                            .opacity(viewModel.currentTab == .all ? 1 : 0)
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
                Spacer()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}

private struct BookRow: View {
    @ObservedObject var viewModel: SearchViewModel
    @State var info: SearchViewModel.BookInfo
    @ObservedObject var imageViewModel: ImageViewModel
    
    init(viewModel: SearchViewModel, info: SearchViewModel.BookInfo) {
        self.viewModel = viewModel
        self.info = info
        self.imageViewModel = ImageViewModel(urlString: info.thumbnailUrl)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if let image = imageViewModel.image {
                ImageView(viewModel: imageViewModel, image: image)
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(info.title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.bottom, 8)
                if !info.authors.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(info.authors, id: \.self) { author in
                            Text(author)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Text(info.type)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .onAppear {
            imageViewModel.load()
        }
    }
}

#Preview {
    @State var redrawId = UUID()
    return SearchView(viewModel: SearchViewModel().asHasSerchedBooks(), redrawId: $redrawId)
}
