//
//  MovieViewModel.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewModel {
    
    /// 네비게이션 타이틀
    let naviTitle: String = "네이버 영화 검색"
    /// 서치바 힌트 텍스트
    let placeHolderText: String = "영화 제목을 입력하세요"
    
    /// 검색어
    let searchText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    /// 조회 결과
    var movieList: BehaviorRelay<[MovieViewModel]> = BehaviorRelay(value: [])
    
    /// 시작 아이템 순서
    private var start: Int = 1
    /// 추가 조회 가능여부
    var hasMoreItemstoRequest: Bool = false
    
    init() {
        
        
    }
    
}

extension MovieListViewModel {
    
    //MARK: - 네트워크 통신
    
    func requestMovieList(isNew: Bool = false) {
        
        if isNew {
            self.start = 1
            self.movieList.accept([])
        } else {
            if true == hasMoreItemstoRequest {
                self.start = self.movieList.value.count + 1 >= 1000 ? 1000 : self.movieList.value.count + 1
            }
        }
        
        APIService.shared.requestMovieList(title: searchText.value, start: self.start) { [self] responseData in
            
            guard let itemList = responseData.items else {
                // error
                return
            }
            
            self.movieList.accept(self.movieList.value + itemList.compactMap {MovieViewModel($0)})
            
            if self.start < 1000 {
                self.hasMoreItemstoRequest = movieList.value.count < (responseData.total ?? 0) ? true : false
            } else {
                self.hasMoreItemstoRequest = false
            }
            
        }
    }
}

struct MovieViewModel {
    
    private let movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
}

extension MovieViewModel {
    
    var movieTitle: String {
        return movie.title ?? ""
    }
    
    var movieDirector: String {
        return movie.director ?? ""
    }
    
    var movieActors: String {
        return movie.actor ?? ""
    }
    
    var movieScore: String {
        return movie.userRating ?? "0"
    }
    
    var posterImageUrl: String {
        return movie.image ?? ""
    }
}
