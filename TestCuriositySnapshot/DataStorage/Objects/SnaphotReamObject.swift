//
//  SnaphotReamObject.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 14.03.2021.
//

import Foundation
import RealmSwift

class SnaphotReamObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var cameraName = ""
    @objc dynamic var imgSrc = ""

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
        super.init()
    }
    
    init(snaphot: Photo) {
        super.init()
        id = snaphot.id
        cameraName = snaphot.camera.name
        imgSrc = snaphot.imgSrc
    }
    
}
