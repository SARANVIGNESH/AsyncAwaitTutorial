//
//  DoCatchThrowsSample.swift
//  AsyncAwaitTutorial
//
//  Created by Saranvignesh Soundararajan on 4/30/24.
//

import SwiftUI

enum CustomError: Error {
    case invalid
}

class DoCatchThrowsManager {
    let isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        } else {
            return (nil, CustomError.invalid)
        }
    }
    
    func getTitle1() -> Result<String, Error> {
        if isActive {
            return .success("New Value")
        } else {
            return .failure(CustomError.invalid)
        }
    }
    
    func getTitle2() throws -> String {
        if isActive {
            return "New Text"
        } else {
            throw CustomError.invalid
        }
    }
}

class DoCatchThrowsViewModel: ObservableObject {
    @Published var text: String = "Hello"
    let manager = DoCatchThrowsManager()

    func fetchTitle() {
        //        let returnedValue = manager.getTitle()
        //        if let newTitle = returnedValue.title {
        //            self.text = newTitle
        //        } else  if let error = returnedValue.error {
        //            self.text = error.localizedDescription
        //        }
//        let result = manager.getTitle1()
//        
//        switch result {
//        case .success(let newTitle):
//            self.text = newTitle
//        case .failure(let error):
//            self.text = error.localizedDescription
//        }
        do {
            let newResult = try manager.getTitle2()
            self.text = newResult
        } catch let error {
            self.text = error.localizedDescription
        }
    }
    
    
    
}

struct DoCatchThrowsSample: View {
    @StateObject private var viewModel = DoCatchThrowsViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.text)
                .frame(width: 300, height: 300)
                .background(Color.blue)
                .onTapGesture {
                    viewModel.fetchTitle()
                }
        }
        .padding()
    }
}

#Preview {
    DoCatchThrowsSample()
}

