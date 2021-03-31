//
//  TodosListViewModel.swift
//  APIotaExample
//
//  Created by Dan Browne on 06/07/2020.
//  Copyright © 2020 Daniel Browne. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif
import APIota

class TodosListViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var todosList: [Todo] = []
    @Published var apiErrorResponse: (showAlert: Bool, error: Error?) = (false, nil)

    // MARK: - Private properties

    private var apiClient: APIotaClient
    private var cancellable: AnyCancellable?

    // MARK: - Initialization

    init(apiClient: APIotaClient = JSONPlaceholdeAPIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Public methods

    /// Updates the todos list from the REST API.
    func updateTodosList() {

        // First, remove existing items from the todos list
        todosList.removeAll()

        // Send the API request for the todos info list
        // (Chaining error handling and property assignment)
        let endpoint = JSONPlaceholderGetTodosEndpoint()
        cancellable = apiClient.sendRequest(for: endpoint)
            .catch({ [unowned self] error -> AnyPublisher<[Todo], Never> in
                self.apiErrorResponse = (true, error)

                return Just([]).eraseToAnyPublisher()
            })
            .assign(to: \.todosList, on: self)
    }
}
