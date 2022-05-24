//
//  MovieModel.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation


struct MovieResponse: Decodable {
    let total: Int?
    let items: [Movie]?
    
    let errorCode: String?
    let errorMessage: String?
}

struct Movie: Decodable {
    let title: String?
    let image: String?
    let director: String?
    let actor: String?
    let userRating: String?
    
}
