//
//  AnimeSaveStatusRepository.swift
//  Animori
//
//  Created by 이빈 on 4/11/25.
//

import Foundation
import RealmSwift

protocol AnimeSaveStatusService {
    func getFileURL()
    func fetchAll() -> [AnimeSaveStatusTable]
    func fetchByStatus(status: AnimeWatchStatus) -> [AnimeSaveStatusTable]
    func create(data: AnimeSaveStatusTable)
    func delete(animeId: String)
    func getAnimeStatus(animeId: Int) -> AnimeWatchStatus?
    func toggleStatus(anime: any AnimeDetailProtocol, status: AnimeWatchStatus)
}

final class AnimeSaveStatusRepository: AnimeSaveStatusService {
    
    private let realm = try! Realm()
    
    func getFileURL() {
        print("Realm DB 경로: \(realm.configuration.fileURL!)")
    }
    
    func fetchAll() -> [AnimeSaveStatusTable] {
        return realm.objects(AnimeSaveStatusTable.self)
            .sorted(byKeyPath: "timestamp", ascending: false)
            .map { $0.freeze() }
    }
    
    func fetchByStatus(status: AnimeWatchStatus) -> [AnimeSaveStatusTable] {
        return realm.objects(AnimeSaveStatusTable.self)
            .filter("status == %@", status)
            .sorted(byKeyPath: "timestamp", ascending: false)
            .map { $0.freeze() }
    }
    
    func create(data: AnimeSaveStatusTable) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
//            print("⚠️ Realm Create Error: \(error.localizedDescription)")
        }
    }
    
    func delete(animeId: String) {
        do {
            let objects = realm.objects(AnimeSaveStatusTable.self)
                .filter("animeId == %@", animeId)
            
            try realm.write {
                realm.delete(objects)
            }
//            print("✅ 삭제 성공")
        } catch {
//            print("⚠️ Realm 삭제 중 오류: \(error.localizedDescription)")
        }
    }
    
    func getAnimeStatus(animeId: Int) -> AnimeWatchStatus? {
        let anime = realm.objects(AnimeSaveStatusTable.self).filter("animeId == %@", animeId).first
        return anime?.status
    }
    
    func toggleStatus(anime: any AnimeDetailProtocol, status: AnimeWatchStatus) {
        // 해당 애니메이션이 이미 같은 상태로 저장되어 있는지 확인
        if let existingAnime = realm.objects(AnimeSaveStatusTable.self).filter("animeId == %@ AND status == %@", anime.id, status).first {
            // 이미 같은 상태로 저장되어 있다면 삭제
            do {
                try realm.write {
                    realm.delete(existingAnime)
                }
//                print("✅ 상태 제거: \(status.rawValue)")
            } catch {
//                print("⚠️ 상태 제거 중 오류: \(error.localizedDescription)")
            }
        } else {
            // 이전에 다른 상태로 저장된 항목이 있는지 확인
            let existingEntries = realm.objects(AnimeSaveStatusTable.self).filter("animeId == %@", anime.id)
            
            // 새로운 상태로 저장
            let newAnimeStatus = AnimeSaveStatusTable(
                animeId: anime.id,
                animeImage: anime.image,
                animeTitle: anime.title,
                animeScore: anime.rate,
                status: status,
                timestamp: Date()
            )
            
            do {
                try realm.write {
                    // 기존 항목들 삭제
                    realm.delete(existingEntries)
                    // 새 항목 추가
                    realm.add(newAnimeStatus)
                }
//                print("✅ 상태 변경: \(status.rawValue)")
            } catch {
//                print("⚠️ 상태 변경 중 오류: \(error.localizedDescription)")
            }
        }
    }
}
