//
//  RecentSearchRepository.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation
import RealmSwift

protocol RecentSearchService {
    func getFileURL()
    func fetchAll() -> [RecentSearchTable]
    func create(data: RecentSearchTable)
    func delete(id: String)
}

final class RecentSearchRepository: RecentSearchService {

    private let realm = try! Realm()

    func getFileURL() {
        print("Realm DB 경로: \(realm.configuration.fileURL!)")
    }

    func fetchAll() -> [RecentSearchTable] {
        return realm.objects(RecentSearchTable.self)
            .sorted(byKeyPath: "timestamp", ascending: false)
            .map { $0.freeze() }
    }

    func create(data: RecentSearchTable) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("⚠️ Realm Create Error: \(error.localizedDescription)")
        }
    }
    
    func delete(id: String) {
        do {
            guard let objectId = try? ObjectId(string: id),
                  let target = realm.object(ofType: RecentSearchTable.self, forPrimaryKey: objectId) else {
                print("⚠️ 올바른 ObjectId가 아님 또는 데이터가 없음")
                return
            }
            try realm.write {
                realm.delete(target)
            }
            print("✅ 삭제 성공")
        } catch {
            print("⚠️ Realm 삭제 중 오류: \(error.localizedDescription)")
        }
    }

}
