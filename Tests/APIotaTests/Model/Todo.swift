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
