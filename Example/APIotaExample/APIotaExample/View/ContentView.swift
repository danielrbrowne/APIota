//
//  ContentView.swift
//  APIotaExample
//
//  Created by Dan Browne on 06/07/2020.
//  Copyright © 2020 Daniel Browne. All rights reserved.
//

import SwiftUI

// swiftlint:disable multiple_closures_with_trailing_closure

struct ContentView: View {
    // View-model is observed for changes to its state via SwiftUI
    @ObservedObject private var viewModel: TodosListViewModel = TodosListViewModel()

    var body: some View {
        NavigationView {
            TodosListView(viewModel: viewModel)
                .navigationBarTitle(Text("Todos List"))
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            self.viewModel.updateTodosList()
                        }
                    ) {
                        Text("Refresh")
                    }
            )
            TodoDetailsView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            .alert(isPresented: $viewModel.apiErrorResponse.showAlert) {
                Alert(title: Text("Error"),
                      // swiftlint:disable:next line_length
                      message: Text(viewModel.apiErrorResponse.error?.localizedDescription ?? "An error has occured. Please try again later."))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
