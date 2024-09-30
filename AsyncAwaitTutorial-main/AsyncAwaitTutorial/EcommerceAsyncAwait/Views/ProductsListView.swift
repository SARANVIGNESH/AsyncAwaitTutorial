//
//  ProductsListView.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 5/21/24.
//

import SwiftUI
import Combine

struct ProductsListView: View {
    @StateObject private var productViewModel = ProductListViewModel()
    @ObservedObject var categoryViewModel: CategoryViewModel

    var body: some View {
        List {
            ForEach(productViewModel.productData, id: \.id) { product in
                Text(product.title)
            }
        }
        .listStyle(.plain)
        .onAppear {
            Task {
                try await productViewModel.fetchProductsData()
            }
        }
        .onReceive(categoryViewModel.selectedCategory, perform: { category in
            print("category is \(category)")
            productViewModel.selectedCategory = category
        })
    }
}

#Preview {
    ProductsListView(categoryViewModel: CategoryViewModel())
}
