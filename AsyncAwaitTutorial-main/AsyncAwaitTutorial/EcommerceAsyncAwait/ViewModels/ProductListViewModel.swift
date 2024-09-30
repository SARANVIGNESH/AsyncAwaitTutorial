//
//  ProductListViewModel.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 5/21/24.
//

import Foundation
import SwiftUI

class ProductListViewModel: ObservableObject {
    private let url = "https://fakestoreapi.com/products/category/"
    @Published var productData: Product = []
    var selectedCategory: String = ""
    
    func fetchProductsData() async throws -> Product {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "\(url)\(selectedCategory)")!)
            let productData = try JSONDecoder().decode(Product.self, from: data)
            print(productData)
            DispatchQueue.main.async {
                self.productData = productData
            }
            return productData
        } catch {
            print("Error is \(error)")
            throw error
        }
    }
}
