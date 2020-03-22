//
//  Constants.swift
//  Covid19Tracker
//
//  Created by Ben Gomm on 22/03/2020.
//  Copyright © 2020 Ben Gomm. All rights reserved.
//

import Foundation


struct Constants {
    static let covidDeathsURL = "https://pomber.github.io/covid19/timeseries.json"
    static let barHeight = CGFloat(300)
}

enum SelectedCountry {
    case uk
    case austria
    case usa
    case italy
    case spain
}
