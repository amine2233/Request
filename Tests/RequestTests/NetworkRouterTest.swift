//
//  NetworkRouterTest.swift
//  Request iOSTests
//
//  Created by Amine Bensalah on 10/06/2018.
//

@testable import Request
import XCTest

class NetworkRouterTest: XCTestCase {
    var networkRouter: NetworkRouter<PostRouter>!
    let session = MockURLSession()

    override func setUp() {
        super.setUp()
        networkRouter = NetworkRouter(session: session, logger: nil)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_request_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        let allEndPoint = PostRouter(.all(page: 1), environement: .develop)
        try? networkRouter.request(allEndPoint) { _, _, _, _ in
            // return data
        }

        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_response_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        let allEndPoint = PostRouter(.all(page: 1), environement: .develop)
        try? networkRouter.response(allEndPoint) { _, _ in
            // return data
        }

        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_jsonRequest_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        let allEndPoint = PostRouter(.all(page: 1), environement: .develop)
        try? networkRouter.jsonRequest(allEndPoint, completion: { (_: String?, _, _) in
            // return data
        })

        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_jsonResponse_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        let allEndPoint = PostRouter(.all(page: 1), environement: .develop)
        try? networkRouter.jsonResponse(allEndPoint, completion: { (_: Response<String>?, _) in
            // return data
        })

        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_download_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        let downloadEndPoint = PostRouter(.thumb(image: "thumb"), environement: .develop)
        try? networkRouter.download(downloadEndPoint, completion: { _, _, _, _ in
            // return data
        })

        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_downloadURL_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }

        networkRouter.download(url, completion: { _, _, _, _ in
            // return data
        })

        XCTAssertEqual(url, session.lastURL)
        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_upload_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        let uploadEndPoint = PostRouter(.thumb(image: "thumb"), environement: .develop)
        try? networkRouter.upload(uploadEndPoint, from: nil, completion: { _, _, _, _ in
            // return data
        })

        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_async_response_resume() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask

        XCTAssertFalse(dataTask.resumeWasCalled)

        let allEndPoint = PostRouter(.all(page: 1), environement: .develop)
        let _: (Response<Data>?, Error?) = try! networkRouter.syncResponse(allEndPoint)

        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_build_request_get_function() {
        let allEndPoint = PostRouter(.all(page: 1), environement: .develop)

        do {
            let request = try networkRouter.buildRequest(from: allEndPoint)

            XCTAssertNotNil(request.url)

            if let absoluteString = request.url?.absoluteString {
                let urlComponents = NSURLComponents(string: absoluteString)
                XCTAssertEqual(urlComponents?.host, allEndPoint.environement.baseUrl)
            }
            XCTAssertEqual(allEndPoint.httpMethod.rawValue, request.httpMethod)

        } catch {
            fatalError("URL can't be empty")
        }
    }

    func test_build_request_post_function() {
        let postEndPoint = PostRouter(.search(query: "swift"), environement: .develop)

        do {
            let request = try networkRouter.buildRequest(from: postEndPoint)

            XCTAssertNotNil(request.url)

            if let absoluteString = request.url?.absoluteString {
                let urlComponents = NSURLComponents(string: absoluteString)
                XCTAssertEqual(urlComponents?.host, postEndPoint.environement.baseUrl)
            }
            XCTAssertEqual(postEndPoint.httpMethod.rawValue, request.httpMethod)

        } catch {
            fatalError("URL can't be empty")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
