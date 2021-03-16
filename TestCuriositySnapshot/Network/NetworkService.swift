//
//  NetworkService.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 13.03.2021.
//

import Foundation
import Alamofire
import Kingfisher

class NetworkService {

    static let shared = NetworkService()
    
    private init() {}
    
    func curiositySnaphotsList(successHandler: @escaping (_ photos: [ShortSnaphotInfo]) -> Void,
                               failureHandler: @escaping (_ mess: Error) -> Void) {
        let yestaday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let yestadayString = formatter.string(from: yestaday ?? Date())
        AF.request(NetworkRouter.snapshotsList(rover: "curiosity", page: 1, date: yestadayString)).responseJSON { (response) in
            switch response.result{
            case .success(_):
                guard let jsonData = response.data else {
    //                failureHandler(nil)
                    return
                }
                do {
                    let snaphotList = try JSONDecoder().decode(SnaphotList.self, from: jsonData)
                    DataStorageService.shared.removeAll()
                    Kingfisher.ImageCache.default.clearCache()
                    DataStorageService.shared.save(snaphotsList: snaphotList.photos)
                    var snaphotsInfo = [ShortSnaphotInfo]()
                    snaphotList.photos.forEach({snaphotsInfo.append(ShortSnaphotInfo(snaphot: $0))})
                    successHandler(snaphotsInfo)
                } catch let error {
                    failureHandler(error)
                }
            case .failure(let error):
                failureHandler(error)
            }
        }
    }
    
}
