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
                    self.updateData()
                }) {
                    Text("Refresh")
                }
                
                Text(lastUpdated)
                    .font(.system(size: 10))
            }

            Text("Total cases: \(dataViewModel.max) (+\(dataViewModel.increase))")
            
            // TODO: fade out on one edge
            ScrollView(.horizontal, showsIndicators: true) {
                VStack(spacing: 5) {
                    HStack (alignment: .bottom, spacing: 4) {
                        ForEach(dataViewModel.dataSet, id: \.self) { day in
                            // Add hover (will need to separate out the bars into own component)
                            // https://stackoverflow.com/questions/58260729/swiftui-not-very-responsive-to-hover-events
                            VStack {
                                Spacer()
                            }
                            .frame(width: 8, height: (CGFloat(day.confirmed) / CGFloat(self.dataViewModel.max)) * Constants.barHeight)
                            .background(Color.red)
                        }
                    }
                    
                    HStack {
                        Text("1st case")
                            .font(.system(size: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Text("Day \(dataViewModel.dataSet.count)")
                            .font(.system(size: 10))
                    }
                    
                    Spacer()
                }
            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
        }
        .padding(.top, 10)
        .onAppear(perform: updateData)
    }
    
    private func updateLastUpdated() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        self.lastUpdated = "Last updated: \(formatter.string(from: now))"
    }
    
    private func updateData() {
        // TODO: How do we ensure data was actually refreshed? Might need to put
        // update of label in a closure
        dataViewModel.refreshData()
        
        updateLastUpdated()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(dataViewModel: ChartViewModel(country: .italy))
    }
}
