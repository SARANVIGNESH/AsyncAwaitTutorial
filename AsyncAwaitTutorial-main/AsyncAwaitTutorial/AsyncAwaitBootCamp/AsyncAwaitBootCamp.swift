//
//  AsyncAwaitBootCamp.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 5/16/24.
//

import SwiftUI

class AsyncAwaitBootCampViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addItem() {
        dataArray.append("Hello")
    }
}


struct AsyncAwaitBootCamp: View {
    @StateObject private var viewModel = AsyncAwaitBootCampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) {data in
                Text(data)
            }
        }
        .onAppear {
            viewModel.addItem()
        }
    }
}

#Preview {
    AsyncAwaitBootCamp()
}
