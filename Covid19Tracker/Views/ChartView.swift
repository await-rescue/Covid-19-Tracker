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
    
    var body: some View {
        VStack(spacing: 15) {
            Button(action: {
                self.dataViewModel.refreshData()
            }) {
                Text("Refresh")
            }
            
            Text("Total deaths: \(dataViewModel.max) (+\(dataViewModel.increase))")
            
            // TODO: fade out on one edge
            ScrollView(.horizontal, showsIndicators: true) {
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
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(dataViewModel: ChartViewModel(country: .italy))
    }
}
