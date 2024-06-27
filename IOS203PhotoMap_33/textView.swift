//
//  textView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/25.
//

import SwiftUI

struct textView: View {
    
    @StateObject var api = GeoApi()
    @StateObject var locationmanager = LocationManager()
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    if let currentLocation = locationmanager.currentLocation {
                        let x = Double(currentLocation.coordinate.longitude)
                        let y = Double(currentLocation.coordinate.latitude)
                        await api.getlocation(x: x, y: y)
                    } else {
                        print("error")
                    }
                }
            }, label: {
                Image(systemName: "bus")
            })
            
                        }
      

    }
}


#Preview {
    textView()
}
