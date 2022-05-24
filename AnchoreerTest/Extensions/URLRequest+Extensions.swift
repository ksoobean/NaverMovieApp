//
//  URLRequest+Extensions.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/24.
//

import Foundation
import RxSwift

extension URLRequest {
    
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                
                var request = URLRequest(url: url)
                request.addValue(resource.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
                request.addValue(resource.clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
                
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}

