import XCTest
#if canImport(Combine)
import Combine
#endif
@testable import APIota

// swiftlint:disable type_body_length multiple_closures_with_trailing_closure

final class APIotaCRUDRequestsTests: XCTestCase {

    // MARK: - Private constants

    private static let apiClient = TestAPIClient()

    // MARK: - Private variables

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    private lazy var cancellable: AnyCancellable? = nil

    #endif

    // MARK: - Test methods

    func testGET() {

        let endpoint = TestTodosGetEndpoint()
        let expectation = XCTestExpectation(description: "testGET")

        Self.apiClient.sendRequest(for: endpoint) { result in
            switch result {
            case .success(let todosList):
                self.verifyTodoList(todosList,
                                    expectedCount: 200,
                                    expectedId: 1,
                                    expectedUserId: 1,
                                    expectedTitle: "delectus aut autem",
                                    expectedCompleted: false)

            case .failure(let error):
                XCTFail("\(expectation.expectationDescription) request should not fail! - failed with: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func testGETPublisher() {

        let endpoint = TestTodosGetEndpoint()
        let expectation = XCTestExpectation(description: "testGETPublisher")

        cancellable = Self.apiClient.sendRequest(for: endpoint)
            .sink(receiveCompletion: { completion in
                self.verifyPublisherCompletion(completion, expectation: expectation)
            }) { todosList in
                self.verifyTodoList(todosList,
                                    expectedCount: 200,
                                    expectedId: 1,
                                    expectedUserId: 1,
                                    expectedTitle: "delectus aut autem",
                                    expectedCompleted: false)

                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 10.0)
    }

    #endif

    func testDELETE() {

        let todoId = 98
        let endpoint = TestTodosUpdateEndpoint(httpMethod: .DELETE, todoId: todoId)
        let expectation = XCTestExpectation(description: "testDELETE")

        Self.apiClient.sendRequest(for: endpoint) { result in
            switch result {
            case .success(let emptyTodo):
                XCTAssertEqual(emptyTodo.id, nil)
                XCTAssertEqual(emptyTodo.userId, nil)
                XCTAssertEqual(emptyTodo.title, nil)
                XCTAssertEqual(emptyTodo.completed, nil)

            case .failure(let error):
                XCTFail("\(expectation.expectationDescription) request should not fail! - failed with: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func testDELETEPublisher() {

        let todoId = 98
        let endpoint = TestTodosUpdateEndpoint(httpMethod: .DELETE, todoId: todoId)
        let expectation = XCTestExpectation(description: "testDELETEPublisher")

        cancellable = Self.apiClient.sendRequest(for: endpoint)
            .sink(receiveCompletion: { completion in
                self.verifyPublisherCompletion(completion, expectation: expectation)
            }) { emptyTodo in
                XCTAssertEqual(emptyTodo.id, nil)
                XCTAssertEqual(emptyTodo.userId, nil)
                XCTAssertEqual(emptyTodo.title, nil)
                XCTAssertEqual(emptyTodo.completed, nil)
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 10.0)
    }

    #endif

    func testPATCH() {

        let todoTitle = "PATCHed TODO"
        let todoId = 98
        let expectedUserId = 5
        let expectedCompletedStatus = true
        let endpoint = TestTodosUpdateEndpoint(httpBody: Todo(title: todoTitle),
                                               httpMethod: .PATCH,
                                               todoId: todoId)
        let expectation = XCTestExpectation(description: "testPATCH")

        Self.apiClient.sendRequest(for: endpoint) { result in
            switch result {
            case .success(let updatedTodo):
                self.verifyTodo(updatedTodo,
                                expectedId: todoId,
                                expectedUserId: expectedUserId,
                                expectedTitle: todoTitle,
                                expectedCompleted: expectedCompletedStatus)

            case .failure(let error):
                XCTFail("\(expectation.expectationDescription) request should not fail - failed with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func testPATCHPublisher() {

        let todoTitle = "PATCHed TODO"
        let todoId = 98
        let expectedUserId = 5
        let expectedCompletedStatus = true
        let endpoint = TestTodosUpdateEndpoint(httpBody: Todo(title: todoTitle),
                                               httpMethod: .PATCH,
                                               todoId: todoId)
        let expectation = XCTestExpectation(description: "testPATCHPublisher")

        cancellable = Self.apiClient.sendRequest(for: endpoint)
            .sink(receiveCompletion: { completion in
                self.verifyPublisherCompletion(completion, expectation: expectation)
            }, receiveValue: { updatedTodo in
                self.verifyTodo(updatedTodo,
                                expectedId: todoId,
                                expectedUserId: expectedUserId,
                                expectedTitle: todoTitle,
                                expectedCompleted: expectedCompletedStatus)
                expectation.fulfill()
            })

        wait(for: [expectation], timeout: 10.0)
    }

    #endif

    func testPOST() {

        let todoTitle = "POSTed TODO"
        let userId = 1
        let completedStatus = true
        let expectedTodoId = 201
        let endpoint = TestTodosCreateEndpoint(httpBody: Todo(userId: userId,
                                                              title: todoTitle,
                                                              completed: completedStatus))
        let expectation = XCTestExpectation(description: "testPOST")

        Self.apiClient.sendRequest(for: endpoint) { result in
            switch result {
            case .success(let createdTodo):
                self.verifyTodo(createdTodo,
                                expectedId: expectedTodoId,
                                expectedUserId: userId,
                                expectedTitle: todoTitle,
                                expectedCompleted: completedStatus)

            case .failure(let error):
                XCTFail("\(expectation.expectationDescription) request should not fail - failed with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func testPOSTPublisher() {

        let todoTitle = "POSTed TODO"
        let userId = 1
        let completedStatus = true
        let expectedTodoId = 201
        let endpoint = TestTodosCreateEndpoint(httpBody: Todo(userId: userId,
                                                              title: todoTitle,
                                                              completed: completedStatus))
        let expectation = XCTestExpectation(description: "testPOSTPublisher")

        cancellable = Self.apiClient.sendRequest(for: endpoint)
            .sink(receiveCompletion: { completion in
                self.verifyPublisherCompletion(completion, expectation: expectation)
            }, receiveValue: { createdTodo in
                self.verifyTodo(createdTodo,
                                expectedId: expectedTodoId,
                                expectedUserId: userId,
                                expectedTitle: todoTitle,
                                expectedCompleted: completedStatus)
                expectation.fulfill()
            })

        wait(for: [expectation], timeout: 10.0)
    }

    #endif

    func testPUT() {

        let todoTitle = "PUTed TODO"
        let todoId = 98
        let userId = 1
        let completedStatus = true
        let endpoint = TestTodosUpdateEndpoint(httpBody: Todo(userId: userId,
                                                              title: todoTitle,
                                                              completed: completedStatus),
                                               httpMethod: .PUT,
                                               todoId: todoId)

        let expectation = XCTestExpectation(description: "testPUT")

        Self.apiClient.sendRequest(for: endpoint) { result in
            switch result {
            case .success(let replacedTodo):
                self.verifyTodo(replacedTodo,
                                expectedId: todoId,
                                expectedUserId: userId,
                                expectedTitle: todoTitle,
                                expectedCompleted: completedStatus)

            case .failure(let error):
                XCTFail("\(expectation.expectationDescription) request should not fail - failed with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func testPUTPublisher() {

        let todoTitle = "PUTed TODO"
        let todoId = 98
        let userId = 1
        let completedStatus = true
        let endpoint = TestTodosUpdateEndpoint(httpBody: Todo(userId: userId,
                                                              title: todoTitle,
                                                              completed: completedStatus),
                                               httpMethod: .PUT,
                                               todoId: todoId)

        let expectation = XCTestExpectation(description: "testPUTPublisher")

        cancellable = Self.apiClient.sendRequest(for: endpoint)
            .sink(receiveCompletion: { completion in
                self.verifyPublisherCompletion(completion, expectation: expectation)
            }, receiveValue: { replacedTodo in
                self.verifyTodo(replacedTodo,
                                expectedId: todoId,
                                expectedUserId: userId,
                                expectedTitle: todoTitle,
                                expectedCompleted: completedStatus)
                expectation.fulfill()
            })

        wait(for: [expectation], timeout: 10.0)
    }

    #endif

    // MARK: - Private methods

    // swiftlint:disable:next function_parameter_count
    private func verifyTodoList(_ todoList: [Todo],
                                expectedCount: Int,
                                expectedId: Int,
                                expectedUserId: Int,
                                expectedTitle: String,
                                expectedCompleted: Bool) {
        XCTAssertEqual(todoList.count, 200)
        XCTAssertEqual(todoList.first!.userId, 1)
        XCTAssertEqual(todoList.first!.id, 1)
        XCTAssertEqual(todoList.first!.title, "delectus aut autem")
        XCTAssertEqual(todoList.first!.completed, false)
    }

    private func verifyTodo(_ todo: Todo,
                            expectedId: Int,
                            expectedUserId: Int,
                            expectedTitle: String,
                            expectedCompleted: Bool) {
        XCTAssertEqual(todo.id, expectedId)
        XCTAssertEqual(todo.userId, expectedUserId)
        XCTAssertEqual(todo.title, expectedTitle)
        XCTAssertEqual(todo.completed, expectedCompleted)
    }

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    private func verifyPublisherCompletion(_ completion: Subscribers.Completion<Error>,
                                           expectation: XCTestExpectation) {
        switch completion {
        case .finished:
            break

        case .failure(let error):
            XCTFail("\(expectation.expectationDescription) request should not fail! - failed with: \(error)")
        }

        expectation.fulfill()
    }

    #endif
}
