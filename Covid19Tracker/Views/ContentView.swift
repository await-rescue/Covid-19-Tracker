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


struct ContentView: View {

    var body: some View {
        
        VStack {
            HStack(spacing: 20) {
                Text("SARS-CoV-2")
                    .font(.system(size: 34, weight: .bold))
            }
            
            TabView {
                
                ChartView(dataViewModel: ChartViewModel(country: .china))
                    .tabItem {
                            Text("China")
                    }
            
                ChartView(dataViewModel: ChartViewModel(country: .austria))
                    .tabItem {
                        Text("Austria")
                    }
                
                ChartView(dataViewModel: ChartViewModel(country: .italy))
                    .tabItem {
                        Text("Italy")
                    }
                
                ChartView(dataViewModel: ChartViewModel(country: .spain))
                    .tabItem {
                        Text("Spain")
                    }
                
                ChartView(dataViewModel: ChartViewModel(country: .uk))
                    .tabItem {
                        Text("UK")
                    }
                
                ChartView(dataViewModel: ChartViewModel(country: .usa))
                    .tabItem {
                        Text("USA")
                    }
            }
            
        }
        .frame(width: 800, height: 600)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
