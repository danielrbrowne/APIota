//
//  JSONPlaceholderGetTodosListEndpoint.swift
//  APIotaExample
//
//  Created by Dan Browne on 06/07/2020.
//  Copyright © 2020 Daniel Browne. All rights reserved.
//

import APIota
import Foundation

struct JSONPlaceholderGetTodosEndpoint: APIotaCodableEndpoint {

    typealias Response = [Todo]
    typealias Body = String

    let headers: HTTPHeaders? = nil

    let httpBody: Body? = nil

    let httpMethod: HTTPMethod = .GET

    let path = "/todos"

    let queryItems: [URLQueryItem]? = nil
}
