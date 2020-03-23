//
//  ChartView.swift
//  Covid19Tracker
//
//  Created by Ben Gomm on 22/03/2020.
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
    @Published var dataSet = [CovidData]()
    
    var selectedCountry: SelectedCountry
    
    var max = 1
    var increase = 0
    
    func refreshData() {
        guard let url = URL(string: Constants.covidDeathsURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            print("☁️ Data fetched")
            // TODO: add error checking
            guard let data = data else { return }
            
            do {
                let timeseries = try JSONDecoder().decode(CovidTimeSeries.self, from: data)
                
                DispatchQueue.main.async {
                    switch self.selectedCountry {
                    case .italy:
                        self.dataSet = timeseries.italy.filter { $0.deaths > 0 }
                    case .uk:
                        self.dataSet = timeseries.unitedKingdom.filter { $0.deaths > 0 }
                    case .spain:
                        self.dataSet = timeseries.spain.filter { $0.deaths > 0 }
                    case .usa:
                        self.dataSet = timeseries.usa.filter { $0.deaths > 0 }
                    case .austria:
                        self.dataSet = timeseries.austria.filter { $0.deaths > 0 }
                    }
                    

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

struct ChartView: View {
    @ObservedObject var dataViewModel: ChartViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Total deaths: \(dataViewModel.max) (+\(dataViewModel.increase))")
            
            HStack (alignment: .bottom, spacing: 4) {
                ForEach(dataViewModel.dataSet, id: \.self) { day in
                    VStack {
                        Spacer()
                    }
                    .frame(width: 8, height: (CGFloat(day.deaths) / CGFloat(self.dataViewModel.max)) * Constants.barHeight)
                    .background(Color.red)
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(dataViewModel: ChartViewModel(country: .italy))
    }
}