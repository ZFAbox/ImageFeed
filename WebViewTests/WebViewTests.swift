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
        XCTAssertTrue(shouldHideProgress)
    }
    
}
