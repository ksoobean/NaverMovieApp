//
//  MovieDetailViewController.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import UIKit
import WebKit

class MovieDetailViewController: UIViewController {
    
    private let viewModel: MovieDetailViewModel!
    
    private let movieInfoView = MovieInfoView()
    private let webView = WKWebView()
    
    init(_ viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configureNavi()
        self.setMovieInfoView()
        self.configureWebview()
    }
    
    /// 네비게이션 셋팅
    private func configureNavi() {
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = self.viewModel.movieInfo.movieTitle
        
    }
    
    /// 영화 정보 뷰 셋팅
    private func setMovieInfoView() {
        self.view.addSubview(movieInfoView)
        
        movieInfoView.translatesAutoresizingMaskIntoConstraints = false
        movieInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        movieInfoView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        movieInfoView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        movieInfoView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        movieInfoView.configureData(with: self.viewModel.movieInfo)
    }
    
    private func configureWebview() {
        
        self.view.addSubview(self.webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: movieInfoView.bottomAnchor,constant: 10).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        guard let url = URL(string: self.viewModel.link) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}
