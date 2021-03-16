//
//  DataStorageService.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 14.03.2021.
//

import Foundation
import RealmSwift


class DataStorageService  {
     static let shared = DataStorageService()
    
    private var realm: Realm!
    
    private var isRealmPrepared = false
    
    private init() {
        prepareRealm()
    }
    
    private func prepareRealm() {
        guard !isRealmPrepared else {
            return
        }
        do {
           realm =  try Realm()
            isRealmPrepared = true
        } catch  {
             isRealmPrepared = false
        }
    }
    
    func save(snaphotsList: [Photo]) {
        prepareRealm()
        try? realm.write{
            snaphotsList.forEach({realm.add(SnaphotReamObject(snaphot: $0), update: .modified)})
        }
    }
    
    func loadAllSnaphots() -> [ShortSnaphotInfo] {
        prepareRealm()
        let realmSnaphots = realm.objects(SnaphotReamObject.self)
        var shortSnaphotInfoArray: [ShortSnaphotInfo] = []
        realmSnaphots.forEach({shortSnaphotInfoArray.append(ShortSnaphotInfo(reamObject: $0))})
        return shortSnaphotInfoArray
    }
    
    func removeAll() {
        try? realm.write {
            realm.delete(realm.objects(SnaphotReamObject.self))
        }
    }
    
    func remove(snaphot: ShortSnaphotInfo) {
        guard let realmSnpahot = realm.objects(SnaphotReamObject.self).first(where: {$0.id == snaphot.id}) else {
            return
        }
        try? realm.write {
            realm.delete(realmSnpahot)
        }
    }
    
    
}
