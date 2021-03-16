//
//  SnapshotsListViewModel.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 14.03.2021.
//

import Foundation
import RxSwift
import RxRelay

class SnapshotsListViewModel {
    let disposeBag = DisposeBag()    
    var snaphotsRelay = BehaviorRelay<[ShortSnaphotInfo]>(value: [])
    var snaphots: [ShortSnaphotInfo] = []
    var urlSingle: Single<Any?>?
    
    func loadFromNetwork() {
        urlSingle = Single<Any?>.create { (single) in
            NetworkService.shared.curiositySnaphotsList(successHandler: {snaphots in
                self.snaphots = snaphots
                self.snaphotsRelay.accept(snaphots)
                single(.success(nil))
            }, failureHandler: {(error) in
                self.loadFromDataStorage()
                if self.snaphotsRelay.value.count > 0 {
                    single(.success(nil))
                } else {
                    single(.failure(error))
                }
            })
            return Disposables.create {}
        }
    }
    
    private func loadFromDataStorage() {
        self.snaphotsRelay.accept( DataStorageService.shared.loadAllSnaphots())
    }
    
    func removeSnaphot(at index: Int) {
        guard index >= 0 && index < snaphots.count else {
            return
        }
        DataStorageService.shared.remove(snaphot: snaphots[index])
        snaphots.remove(at: index)
        snaphotsRelay.accept(snaphots)
    }
}
