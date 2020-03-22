//
//  CovidTimeSeries.swift
//  Covid19Tracker
//
//  Created by Ben Gomm on 22/03/2020.
//  Copyright © 2020 Ben Gomm. All rights reserved.
//

import Foundation

struct CovidData: Codable, Hashable {
    let date: String
    let confirmed: Int
    let deaths: Int
    let recovered: Int
}

struct CovidTimeSeries: Codable {
    let unitedKingdom: [CovidData]
    let austria: [CovidData]
    let italy: [CovidData]
    let spain: [CovidData]
    let usa: [CovidData]
}

extension CovidTimeSeries {
    enum CodingKeys: String, CodingKey {
        case unitedKingdom = "United Kingdom"
        case austria = "Austria"
        case italy = "Italy"
        case spain = "Spain"
        case usa = "US"
    }
}
