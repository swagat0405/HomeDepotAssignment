//
//  Repo.swift
//  HomeDepotAssignment
//
//  Created by Swagat Mishra on 5/2/18.
//  Copyright © 2018 Swagat Mishra. All rights reserved.
//

import Foundation

class Repo: Codable {
    var repoIdentifier: Int?
    var name: String?
    var description: String?
    var createdAt: String?
    var license: License?
    
    enum CodingKeys: String, CodingKey {
        case repoIdentifier = "id"
        case createdAt = "created_at"
        case name, description, license
    }
}

class License: Codable {
    var name: String?
}
