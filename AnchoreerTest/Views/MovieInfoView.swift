//
//  MoviewInfoView.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/24.
//

import UIKit
import RxSwift

class MovieInfoView: UIView {

    private let disposeBag = DisposeBag()
    private var movieVM: MovieViewModel!
    
    @IBOutlet weak var posterImageView: UIImageView! // 영화 포스터 사진
    @IBOutlet weak var movieTitleLabel: UILabel! // 영화제목
    @IBOutlet weak var directorLabel: UILabel! // 감독
    @IBOutlet weak var actorsLabel: UILabel! // 배우
    @IBOutlet weak var scoreLabel: UILabel! // 평점
    @IBOutlet weak var bookMarkButton: UIButton! // 북마크 버튼
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        let view = Bundle.main.loadNibNamed("MovieInfoView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
        
        self.setUI()
    }
    
    private func setUI() {
        
        posterImageView.contentMode = .scaleToFill
        
        movieTitleLabel.font = .boldSystemFont(ofSize: 20)
        movieTitleLabel.textColor = .black
        
        directorLabel.font = .systemFont(ofSize: 16)
        directorLabel.textColor = .black
        
        actorsLabel.font = .systemFont(ofSize: 16)
        actorsLabel.textColor = .black
        
        scoreLabel.font = .systemFont(ofSize: 16)
        scoreLabel.textColor = .black
        
        bookMarkButton.setImage(UIImage(systemName: "star"), for: .normal)
        bookMarkButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        bookMarkButton.tintColor = .systemYellow
        
        // 즐겨찾기 버튼
        bookMarkButton.rx.tap
          .scan(false) { lastState, newState in !lastState }
          .bind { isSelected in
              if isSelected {
                  self.bookMarkButton.isSelected = true
                  Database.shared.add(item: self.movieVM)
              } else {
                  self.bookMarkButton.isSelected = false
                  Database.shared.remove(item: self.movieVM)
              }
          }
          .disposed(by: self.disposeBag)
        
    }
    
    public func clearData() {
        
        posterImageView.image = nil
        movieTitleLabel.text = nil
        directorLabel.text = nil
        actorsLabel.text = nil
        scoreLabel.text = nil
    }
    
    public func configureData(with vm: MovieViewModel) {
        
        self.movieVM = vm
        
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
