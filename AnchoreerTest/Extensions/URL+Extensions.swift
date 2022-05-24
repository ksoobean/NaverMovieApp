//
//  URL+Extensions.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/24.
//

import Foundation


struct Resource<T: Decodable> {
    let url: URL
    
    let clientID: String = "HLSeDOlKrZYbTxDwtwGx"
    let clientKEY: String = "as1AevMOlo"
    
}


extension URL {
    
    static func urlForMovieList(title: String, start: Int) -> URL? {
        let encodedTitle: String = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
              
        return URL(string: "https://openapi.naver.com/v1/search/movie.json?query=\(encodedTitle)&start=\(start)")
    }
}
