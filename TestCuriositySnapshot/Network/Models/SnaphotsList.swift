//
//  SnaphotsList.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 13.03.2021.
//

import Foundation

// MARK: - ShortSnaphotInfo
struct ShortSnaphotInfo {
    let id: Int
    let cameraName: String
    let imgSrc: String
    
    init(id: Int, cameraName: String, imgSrc: String) {
        self.id = id
        self.cameraName = cameraName
        self.imgSrc = imgSrc
    }
    
    init(snaphot: Photo) {
        self.id = snaphot.id
        self.cameraName = snaphot.camera.name
        self.imgSrc = snaphot.imgSrc
    }
    
    init(reamObject snaphot: SnaphotReamObject) {
        self.id = snaphot.id
        self.cameraName = snaphot.cameraName
        self.imgSrc = snaphot.imgSrc
    }
}

// MARK: - SnaphotList
struct SnaphotList: Codable {
    let photos: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover

    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

// MARK: - Camera
struct Camera: Codable {
    let id: Int
    let name: String
    let roverID: Int
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case roverID = "rover_id"
        case fullName = "full_name"
    }
}

// MARK: - Rover
struct Rover: Codable {
    let id: Int
    let name: String
    let landingDate, launchDate: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
    }
}
