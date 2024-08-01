//
//  SearchBar.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: SearchBarViewModel
    @Binding var text: String
    @FocusState var isFocus: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search", text: $text)
                .foregroundColor(.primary)
                .font(.title3)
                .submitLabel(.search)
                .focused($isFocus)
                .onSubmit {
                    viewModel.searchButtonPressed.send(text)
                }
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            } else {
                EmptyView()
            }
        }
        .padding(.all, 8)
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
        .padding(.horizontal, 20)
        .onAppear {
            isFocus = true
        }
    }
}

private struct SearchPreviewView: View {
    let array = [
        "apple", "bAnana", "carrot", "dog", "elephant", "flower", "guitar", "happy", "island", "jazz", "kangaroo", "laptop", "mountain", "notebook", "ocean", "puzzle", "quasar", "rainbow", "sunshine", "tiger", "umbrella", "vibrant", "wonderful", "xylophone", "yellow", "zeppelin"
    ]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(viewModel: SearchBarViewModel(), text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                List {
                    ForEach(array.map { $0.lowercased() }.filter { $0.hasPrefix(searchText.lowercased()) || searchText.isEmpty }, id: \.self) { searchText in
                        Text(searchText)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("검색기능")
        }
    }
}

#Preview {
    SearchPreviewView()
}

