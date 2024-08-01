//
//  KidsnotePreProjectApp.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import SwiftUI

@main
struct kidsnote_pre_projectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

