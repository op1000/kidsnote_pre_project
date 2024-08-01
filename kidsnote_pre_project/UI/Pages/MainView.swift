//
//  MainView.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import SwiftUI

struct MainView: View {
    @State private var searchText = ""
    @State private var redrawId = UUID()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    SearchView(viewModel: SearchViewModel(), redrawId: $redrawId)
                } label: {
                    SearchBar(viewModel: SearchBarViewModel(), text: $searchText)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .disabled(true)
                }
                Spacer()
            }
            .navigationTitle("메인 화면")
            .id(redrawId)
            .onAppear {
                redrawId = UUID()
            }
        }
    }
}

#Preview {
    MainView()
}
