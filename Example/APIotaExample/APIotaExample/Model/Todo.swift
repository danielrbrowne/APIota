//
//  Todo.swift
//  APIotaExample
//
//  Created by Dan Browne on 06/07/2020.
//  Copyright © 2020 Daniel Browne. All rights reserved.
//

import Foundation

struct Todo: Codable {
    let id: Int?
    let userId: Int?
    let title: String?
    let completed: Bool?

    init(id: Int? = nil, userId: Int? = nil, title: String? = nil, completed: Bool? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.completed = completed
    }
}

extension Todo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(userId)
        hasher.combine(title)
        hasher.combine(completed)
    }
}
