//
//  MovieListCell.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import UIKit
import RxSwift

class MovieListCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView! // 영화 포스터 사진
    @IBOutlet weak var movieTitleLabel: UILabel! // 영화제목
    @IBOutlet weak var directorLabel: UILabel! // 감독
    @IBOutlet weak var actorsLabel: UILabel! // 배우
    @IBOutlet weak var scoreLabel: UILabel! // 평점
    @IBOutlet weak var bookMarkButton: UIButton! // 북마크 버튼
    
    static let identifier: String = "MovieListCell"
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.contentMode = .scaleToFill
        
        movieTitleLabel.font = .boldSystemFont(ofSize: 20)
        movieTitleLabel.textColor = .black
        
        directorLabel.font = .systemFont(ofSize: 16)
        directorLabel.textColor = .black
        
        actorsLabel.font = .systemFont(ofSize: 16)
        actorsLabel.textColor = .black
        
        scoreLabel.font = .systemFont(ofSize: 16)
        scoreLabel.textColor = .black
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
        movieTitleLabel.text = nil
        directorLabel.text = nil
        actorsLabel.text = nil
        scoreLabel.text = nil
    }
    
    public func configureCell(with vm: MovieViewModel) {
        
        self.movieTitleLabel.text = vm.movieTitle
        self.directorLabel.text = vm.movieDirector
        self.actorsLabel.text = vm.movieActors
        self.scoreLabel.text = vm.movieScore
        
        APIService.shared.requestPosterImage(with: vm.posterImageUrl)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] image in
                self?.posterImageView.image = image
            } onCompleted: {
                UIView.animate(withDuration: 0.2) {
                    self.posterImageView.alpha = 1
                }
            }.disposed(by: self.disposeBag)
    }
    
}
