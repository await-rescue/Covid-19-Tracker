//
//  ChartView.swift
//  Covid19Tracker
//
//  Created by Ben Gomm on 22/03/2020.
//  Copyright © 2020 Ben Gomm. All rights reserved.
//

import SwiftUI


struct ChartView: View {
    @ObservedObject var dataViewModel: ChartViewModel
    
    @State private var lastUpdated: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            
            HStack {
                Button(action: {
                    // TODO: How do we ensure data was actually refreshed? Might need to put
                    // update of label in a closure
                    self.dataViewModel.refreshData()
                    self.updateLastUpdated()
                }) {
                    Text("Refresh")
                }
                
                Text(lastUpdated)
                    .font(.system(size: 10))
            }

            Text("Total deaths: \(dataViewModel.max) (+\(dataViewModel.increase))")
            
            // TODO: fade out on one edge
            ScrollView(.horizontal, showsIndicators: false) {
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
            .padding(.leading, 50)
            .padding(.trailing, 50)
        }
        .onAppear(perform: updateLastUpdated)
        .onAppear(perform: dataViewModel.refreshData)
    }
    
    func updateLastUpdated() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        self.lastUpdated = "Last updated: \(formatter.string(from: now))"
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(dataViewModel: ChartViewModel(country: .italy))
    }
}
