//
//  DownloadAsyncImageView.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 4/30/24.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
        
    }
    func downloadWithEscaping(completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data,
//                  let image = UIImage(data: data),
//                  let response = response as? HTTPURLResponse,
//                  response.statusCode >= 200 && response.statusCode < 300 else {
//                return
//            }
            let image = self.handleResponse(data: data, response: response)
            completion(image, nil)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError{ $0 }
            .eraseToAnyPublisher()
    }
    
    func downlaodWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let image = handleResponse(data: data, response: response)
            return image
        } catch {
            throw error
        }
        
    }
}

class DownloadAsyncImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    private var cancellable = Set<AnyCancellable>()
    
    func fetchImage() async {
//        self.image = UIImage(systemName: "circle.fill")
//        loader.downloadWithEscaping { [weak self] image, error in
//            if let image = image {
//                self?.image = image
//            }
//        }
        
//        loader.downloadWithCombine()
//            .sink { _ in
//                
//            } receiveValue: { image in
//                DispatchQueue.main.async {
//                    self.image = image
//                }
//            }
//            .store(in: &cancellable)
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        let image = try? await loader.downlaodWithAsync()
        self.image = image

    }
}

struct DownloadAsyncImageView: View {
    @StateObject var viewModel = DownloadAsyncImageViewModel()
    @State private var task: Task<(), Never>?

    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onDisappear {
            task?.cancel()
        }
        .onAppear {
            task = Task {
                await viewModel.fetchImage()
            }
//            viewModel.fetchImage()
            
            Task(priority: .low, operation: {
                print("low: \(Thread.current) : \(Task.currentPriority.rawValue)")
            })
        }
    }
}

#Preview {
    DownloadAsyncImageView()
}
