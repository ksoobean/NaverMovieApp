//
//  Database.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/25.
//

import Foundation

class Database {
    
    private let FAV_KEY: String = "FavoriteListKey"
    
    
    static let shared = Database()
    
    /// UserDefaults에 저장하기
    func save(items: [MovieViewModel]) {
        
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: FAV_KEY)

        }
    }
    
    /// 리스트에 아이템 추가하기
    func add(item: MovieViewModel) {
        var currentList = self.load()
        currentList.append(item)
        self.save(items: currentList)
    }
    
    /// 저장된 리스트 조회하기
    func load() -> [MovieViewModel] {
        if let data = UserDefaults.standard.data(forKey: FAV_KEY) {
            let array = try! JSONDecoder().decode([MovieViewModel].self, from: data)
            return array
        }
        return []
    }
    
    /// 저장된 리스트에서 아이템 삭제하기
    func remove(item: MovieViewModel) {
        var currentList = self.load()
        currentList = currentList.filter {$0.movieTitle != item.movieTitle}
        self.save(items: currentList)
    }
    
    /// 저장된 리스트 모두 삭제
    func removeAll() {
        UserDefaults.standard.removeObject(forKey: FAV_KEY)
    }
}
