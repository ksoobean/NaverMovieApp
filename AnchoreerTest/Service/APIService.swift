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
        
        let clientID: String = "HLSeDOlKrZYbTxDwtwGx"
        let clientKEY: String = "as1AevMOlo"
        
        guard let encodedTitle: String = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://openapi.naver.com/v1/search/movie.json?query=\(encodedTitle)&start=\(start)") else {
            return
        }
        let resource = Resource<MovieResponse>(url: url, clientID: clientID, clientKey: clientKEY)
        
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



struct Resource<T: Decodable> {
    let url: URL
    let clientID: String
    let clientKey: String
}

extension URLRequest {
    
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                
                var request = URLRequest(url: url)
                request.addValue(resource.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
                request.addValue(resource.clientKey, forHTTPHeaderField: "X-Naver-Client-Secret")
                
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}

