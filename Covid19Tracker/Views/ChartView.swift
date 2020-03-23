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
        VStack(spacing: 10) {
            Text("Total deaths: \(dataViewModel.max) (+\(dataViewModel.increase))")
            
            HStack (alignment: .bottom, spacing: 4) {
                ForEach(dataViewModel.dataSet, id: \.self) { day in
                    VStack {
                        Spacer()
                    }
                    // TODO: width should be adaptive for when we have a lot of data
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
