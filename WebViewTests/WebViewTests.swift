//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Fedor on 23.05.2024.
//


@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    final class WebViewPresenterSpy: WebViewPresenterProtocol {
        var viewDidLoadCalled: Bool = false
        var view: ImageFeed.WebViewViewControllerProtocol?
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
        
        func didUpdateProgresValue(_ newValue: Double) {
            
        }
        
        func code(from url: URL) -> String? {
            return nil
        }
    }
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ShowWebView") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
        var loadIsCalled: Bool = false
        var presenter: ImageFeed.WebViewPresenterProtocol?
        
        func setProgressValue(_ newValue: Float) {
            
        }
        
        func setProgressIsHidden(_ isHidden: Bool) {
            
        }
        
        func load(request: URLRequest) {
            loadIsCalled = true
        }
    }
    
    func testWebViewViewControllerLoadIsCalled (){
        //given
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "")
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadIsCalled)
    }
    
    
    func testProgreeVisibaleWhenLessThenOne(){
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progrees: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progrees)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgreeHideWhenOne(){
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progrees: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progrees)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL(){
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString = url?.absoluteString
        
        //then
        XCTAssertTrue(urlString!.contains(configuration.authURLString))
        XCTAssertTrue(urlString!.contains(configuration.accessKey))
        XCTAssertTrue(urlString!.contains(configuration.redirectURI))
        XCTAssertTrue(urlString!.contains("code"))
        XCTAssertTrue(urlString!.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
        let authCodeURLString = "https://unsplash.com/oauth/authorize/native"
        let testCode = "test code"
        guard var urlComponents = URLComponents(string: authCodeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: URLQueryItemsList.code.rawValue, value: testCode)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let returnedCode = authHelper.code(from: url)
        XCTAssertEqual(testCode, returnedCode)
    }
}
