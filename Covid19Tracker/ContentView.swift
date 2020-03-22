//
//  ContentView.swift
//  Covid19Tracker
//
//  Based on https://www.youtube.com/watch?v=aBsZRqtCBU4&t=613s
//
//  Created by Ben Gomm on 22/03/2020.
//  Copyright © 2020 Ben Gomm. All rights reserved.
//

import SwiftUI

class ChartViewModel: ObservableObject {
    @Published var dataSet = [CovidData]()
    
    var max = 1
    
    init() {
        guard let url = URL(string: Constants.covidDeathsURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            // TODO: add error checking
            guard let data = data else { return }
            
            do {
                let timeseries = try JSONDecoder().decode(CovidTimeSeries.self, from: data)
                
                DispatchQueue.main.async {
                    self.dataSet = timeseries.italy.filter { $0.deaths > 0 }

                    let maxData = self.dataSet.max { $0.deaths < $1.deaths }
                    if let maxData = maxData {
                        self.max = maxData.deaths
                    }
                }
               
            } catch {
                print("JSON decode failed: \(error)")
            }
        }.resume()
    }
}

struct Chart: View {
    @ObservedObject var dataViewModel = ChartViewModel()
    
    var body: some View {
        VStack {
            Text("Total deaths: \(dataViewModel.max)")
            
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

struct ContentView: View {
    var body: some View {
        
        VStack {
            Text("SARS-CoV-2")
                .font(.system(size: 34, weight: .bold))
            
            Chart()
        }
        .frame(width: 800, height: 600)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
