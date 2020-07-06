//
//  TodosListView.swift
//  APIotaExample
//
//  Created by Dan Browne on 06/07/2020.
//  Copyright © 2020 Daniel Browne. All rights reserved.
//

import Foundation
import SwiftUI

struct TodosListView: View {
    @ObservedObject var viewModel: TodosListViewModel

    var body: some View {
        List {
            ForEach(viewModel.todosList, id: \.self) { todo in
                NavigationLink(
                    destination: TodoDetailsView(selectedTodo: todo)
                ) {
                    Text("\(todo.title!)")
                }
            }
        }.onAppear {
            // Initial update of list view
            // (i.e. don't refresh every time the user returns to the list)
            if self.viewModel.todosList.count == 0 {
                self.viewModel.updateTodosList()
            }
        }
    }
}
