//
//  CategoryViewModel.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 5/21/24.
//

import SwiftUI
import Combine


class CategoryViewModel: ObservableObject {
    private let url = "https://fakestoreapi.com/products/categories"
    @Published var categoryData: CategoryModel = []
    private var cancellables = Set<AnyCancellable>()
    var selectedCategory = CurrentValueSubject<String,Never>("")

    
    // Using async anwait to fetch categories api
    func getCategoryDataAsync() async throws -> CategoryModel {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let categoryData = try JSONDecoder().decode(CategoryModel.self, from: data)
            DispatchQueue.main.async {
                self.categoryData = categoryData
            }
            return categoryData
        } catch {
            print("Error is \(error)")
            throw error
        }
    }
    
    // Using combine to fetch
    func getCategoryDataCombine() {
        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .decode(type: CategoryModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error is \(error)")
                case .finished:
                    print("Success")
                }
            } receiveValue: { categoryData in
                self.categoryData = categoryData
            }
            .store(in: &cancellables)
            
    }
}
