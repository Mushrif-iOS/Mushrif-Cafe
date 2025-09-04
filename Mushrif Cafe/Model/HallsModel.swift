//
//  HallsModel.swift
//  Mushrif Cafe
//
//  Created by bhikhu on 22/07/25.
//

import Foundation
import Foundation
import SwiftyJSON

struct HallResponseModel {
    let success: Bool
    let message: String
    let sections: [SectionModel]

    init(json: JSON) {
        self.success = json["success"].boolValue
        self.message = json["message"].stringValue
        self.sections = json["response"].arrayValue.map { SectionModel(json: $0) }
    }
}


import Foundation
import SwiftyJSON

struct SectionModel {
    let id: Int?
    let name: String?
    let nameAr: String?
    let capacity: Int?
    let rows: Int?
    let columns: Int?
    let description: String?
    let descriptionAr: String?
    let css: String?
    let status: Int?
    let position: Int?
    let userId: Int?
    let businessId: Int?
    let createdAt: String?
    let updatedAt: String?

    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.nameAr = json["name_ar"].string
        self.capacity = json["capacity"].int
        self.rows = json["rows"].int
        self.columns = json["columns"].int
        self.description = json["description"].string
        self.descriptionAr = json["description_ar"].string
        self.css = json["css"].string
        self.status = json["status"].int
        self.position = json["position"].int
        self.userId = json["user_id"].int
        self.businessId = json["business_id"].int
        self.createdAt = json["created_at"].string
        self.updatedAt = json["updated_at"].string
    }
}

struct HallAssignmentResponse {
    let success: Bool
    let message: String
    let data: HallAssignment?

    init(json: JSON) {
        self.success = json["success"].boolValue
        self.message = json["message"].stringValue
        self.data = HallAssignment(json: json["response"])
    }
}

import SwiftyJSON

struct HallAssignment {
    let hallId: Int?
    let tableId: Int?
    let groupId: Int?
    let groupNumber: Int?
    let tableNameFull: String?
    let tableName: String?

    init(json: JSON) {
        self.hallId = json["hall_id"].int
        self.tableId = json["table_id"].int
        self.groupId = json["group_id"].int
        self.groupNumber = json["group_number"].int
        self.tableNameFull = json["table_name_full"].string
        if let tableNameInt = json["table_name"].int {
            self.tableName = String(tableNameInt) // convert Int to String if needed
        } else {
            self.tableName = json["table_name"].string
        }
    }
}


