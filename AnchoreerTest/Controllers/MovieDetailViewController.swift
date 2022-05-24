//
//  MovieDetailViewController.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    
    private let viewModel: MovieDetailViewModel!
    
    private var movieInfoView = MovieInfoView()
    
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
}
