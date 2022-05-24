//
//  String+Extensions.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/24.
//

import Foundation

extension String {
    /// HTML 태그 제거(movie.title <b></b>)
    var removeHTMLTag: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
    
    var setPeopleList: String {
        if self.isEmpty {
            return ""
        } else {
            let list = self.components(separatedBy: "|").filter {!$0.isEmpty}
            
            return list.joined(separator: ", ")
        }
    }
}
