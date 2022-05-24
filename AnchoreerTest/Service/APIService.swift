//
//  APIService.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import RxSwift
import RxCocoa

class APIService {
    
    static let shared = APIService()
    private var disposeBag = DisposeBag()
    
    //MARK: - 영화 리스트 조회하기
    
    /// 영화 리스트 조회하기
    /// - Parameters:
    ///   - title: 영화 제목
    ///   - pageCount: 페이지카운트(1부터)
    ///   - completeHandler: (UserResponse) -> Void
    func requestMovieList(title: String,
                          start: Int = 1,
                         completeHandler: @escaping (MovieResponse) -> Void) {
        
        guard let url = URL.urlForMovieList(title: title, start: start) else {
            return
        }
        
        let resource = Resource<MovieResponse>(url: url)
        
        URLRequest.load(resource: resource)
            .delay(.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { response in
                completeHandler(response)
            }).disposed(by: disposeBag)
        
    }
    
    //MARK: - URL로부터 포스터 이미지 데이터 추출하기
    
    /// URL로부터 포스터 이미지 데이터 추출하기
    /// - Parameter urlString: avatar_url
    /// - Returns: Observable<UIImage>
    func requestPosterImage(with urlString: String) -> Observable<UIImage> {
        
        guard let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
            return Observable.empty()
        }
        
        return Observable.just(image)
        
      }

}


