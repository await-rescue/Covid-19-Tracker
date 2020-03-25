//
//  ChartViewModel.swift
//  Covid-19 Tracker
//
//  Created by Ben Gomm on 23/03/2020.
//  Copyright © 2020 Ben Gomm. All rights reserved.
//

import SwiftUI

enum SelectedCountry {
    case uk
    case austria
    case usa
    case italy
    case spain
}

class ChartViewModel: ObservableObject {
    // MARK: - Properties
    @Published var dataSet = [CovidData]()
    var selectedCountry: SelectedCountry
    var max = 1
    var increase = 0
    
    // MARK: - Methods
    func filterData(data: CovidTimeSeries, by country: SelectedCountry) -> [CovidData] {
        // If we use an EnvironmentObject, we might as well make dataset a computed property
        switch country {
        case .italy:
            return data.italy.filter { $0.deaths > 0 }
        case .uk:
            return data.unitedKingdom.filter { $0.deaths > 0 }
        case .spain:
            return data.spain.filter { $0.deaths > 0 }
        case .usa:
            return data.usa.filter { $0.deaths > 0 }
        case .austria:
            return data.austria.filter { $0.deaths > 0 }
        }
        
    }
    
    func refreshData() {
        guard let url = URL(string: Constants.covidDeathsURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            print("☁️ Data fetched")
            // TODO: add error checking
            guard let data = data else { return }
            
            do {
                let timeseries = try JSONDecoder().decode(CovidTimeSeries.self, from: data)
                
                DispatchQueue.main.async {
                    
                    self.dataSet = self.filterData(data: timeseries, by: self.selectedCountry)

                    let maxData = self.dataSet.max { $0.deaths < $1.deaths }
                    if let maxData = maxData {
                        self.max = maxData.deaths
                    }
                    
                    let lastIndex = self.dataSet.count - 1
                    // Should probably check if elements exist
                    self.increase = self.dataSet[lastIndex].deaths - self.dataSet[lastIndex - 1].deaths
                    
                }
               
            } catch {
                print("JSON decode failed: \(error)")
            }
        }.resume()
    }
    
    init(country: SelectedCountry) {
        self.selectedCountry = country
        refreshData()
    }
}
