//
//  TodoDetailsView.swift
//  APIotaExample
//
//  Created by Dan Browne on 06/07/2020.
//  Copyright © 2020 Daniel Browne. All rights reserved.
//

import Foundation
import SwiftUI

struct TodoDetailsView: View {
    var selectedTodo: Todo?

    var body: some View {
        Group {
            if selectedTodo != nil {
                VStack(spacing: 20.0) {
                    Text("\(selectedTodo!.title!)")
                        .font(.system(size: 24.0))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.leading, 20.0)
                        .padding(.trailing, 20.0)
                    Text("Completed?: \(selectedTodo!.completed! ? "YES" : "NO")")
                    Text("Item ID: \(selectedTodo!.id!)")
                    Text("User ID: \(selectedTodo!.userId!)")
                }
            } else {
                Text("Todo details will appear here…")
                    .foregroundColor(.gray)
            }
        }.navigationBarTitle(Text("Todo Item"))
    }
}
