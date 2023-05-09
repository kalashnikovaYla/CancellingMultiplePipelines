//
//  ContentView.swift
//  CancellingMultiplePipelines
//
//  Created by sss on 09.05.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel = CancellingMultiplePipelinesViewModel()
    
    var body: some View {
        Group {
            
            HStack {
                TextField("Enter name", text: $viewModel.firstName)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.firstNameValidation)
            }
            
            HStack {
                TextField("Enter lastName", text: $viewModel.lastName)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.lastNameValidation)
            }
        }
        .padding()
        
        Button {
            viewModel.cancelAllValidations()
        } label: {
            Text("Cancel all operations")
        }

    }
}

class CancellingMultiplePipelinesViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    
    private var validationCancellables: Set<AnyCancellable> = []
    
    init() {
        $firstName
            .map{$0.isEmpty ? "🔐" : "💗"}
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $lastName
            .map{$0.isEmpty ? "🔐" : "💗"}
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellables)
    }
    
    func cancelAllValidations() {
        firstNameValidation = ""
        lastNameValidation = "" 
        validationCancellables.removeAll()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
