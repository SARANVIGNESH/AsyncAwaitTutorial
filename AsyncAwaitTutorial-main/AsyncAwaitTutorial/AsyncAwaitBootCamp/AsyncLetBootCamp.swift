//
//  AsyncLetBootCamp.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 5/20/24.
//

import SwiftUI

struct AsyncLetBootCamp: View {
    @State private var images: [UIImage] = []
    let coloumns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!

    var body: some View {
        NavigationView(content: {
            ScrollView {
                LazyVGrid(columns: coloumns, content: {
                    ForEach(images, id: \.self, content: { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    })
                })
            }
            .navigationTitle("Async Let")
            .onAppear {
                //                images.append(UIImage(systemName: "heart.fill")!)
                Task {
                    do {
                        // Async let
//                        async let fetchImage1 = fetchImage()
//                        async let fetchImage2 = fetchImage()
//                        async let fetchImage3 = fetchImage()
//                        async let fetchImage4 = fetchImage()
//                        
//                        let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
//                        self.images.append(contentsOf: [image1, image2, image3, image4])

                        // Multiple aync calls
//                        let image1 = try await fetchImage()
//                        images.append(image1)
//                        
//                        let image2 = try await fetchImage()
//                        images.append(image2)
//                        
//                        let image3 = try await fetchImage()
//                        images.append(image3)
//                        
//                        let image4 = try await fetchImage()
//                        images.append(image4)
                        
                        // Task group
                        try await withThrowingTaskGroup(of: UIImage.self, body: { group in
                            group.addTask(operation: {
                                try await fetchImage()
                            })
                            group.addTask(operation: {
                                try await fetchImage()
                            })
                            group.addTask(operation: {
                                try await fetchImage()
                            })
                            group.addTask(operation: {
                                try await fetchImage()
                            })
                            
                            for try await image in group {
                                images.append(image)
                            }
                            
                        })
                    } catch {
                        
                    }
                }
            }
        }
        )
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

#Preview {
    AsyncLetBootCamp()
}
