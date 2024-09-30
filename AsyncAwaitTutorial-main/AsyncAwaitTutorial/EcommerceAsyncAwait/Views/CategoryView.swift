//
//  CategoryView.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 5/21/24.
//

import SwiftUI
import Combine

struct CategoryView: View {
    @StateObject private var categoryViewModel = CategoryViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categoryViewModel.categoryData, id: \.self) { category in
                    NavigationLink(destination: ProductsListView(categoryViewModel: categoryViewModel)) {
                        Text(category)
                            .onTapGesture {
                                categoryViewModel.selectedCategory.send(category)
                            }
                    }
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle("Categories")
        }
        .onAppear {
            Task {
                try await categoryViewModel.getCategoryDataAsync()
            }
            //            categoryViewModel.getCategoryDataCombine()
            
        }
        
    }
}

#Preview {
    CategoryView()
}
