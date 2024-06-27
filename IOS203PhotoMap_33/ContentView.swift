//
//  ContentView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/5/21.
//

import SwiftUI
import MapKit
import PhotosUI
import CoreData

struct ContentView: View {
    
    @State var captureImage: UIImage? = nil
    @State var isShowSheet = false
    @State var isShowActivity = false
    @State var isPhotoLibrary = false
    @State var selectedItem: PhotosPickerItem?
    @ObservedObject var manager = LocationManager()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: PhotoSpot.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PhotoSpot.createdAt, ascending: false)]
    ) var photoSpots: FetchedResults<PhotoSpot>
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Map(initialPosition: .region(MKCoordinateRegion(center: .jec, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)))) {
                    ForEach(photoSpots) { photoSpot in
                        let coordinate = CLLocationCoordinate2D(latitude: photoSpot.latitude, longitude: photoSpot.longitude)
                        Annotation(photoSpot.title ?? "", coordinate: coordinate) {
                            VStack {
                                if let imageData = photoSpot.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60)
                                } else {
                                    Image("noimage")
                                }
                            }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                    .mapControlVisibility(.visible)
            }
            .onAppear {
                manager.manager.requestWhenInUseAuthorization()
                manager.manager.stopUpdatingLocation()
                print("Photo spots count: \(photoSpots.count)")
                for spot in photoSpots {
                    print("Spot: \(spot.title ?? "No Title"), \(spot.latitude), \(spot.longitude)")
                }
            }
            
            VStack {
                NavigationLink {
                    MemoList()
                } label: {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                }
                
                
                
                NavigationLink {
                    AddImageMemoView()
                } label: {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 50))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.pink)
                }
                .padding()
            }
        }
    }
}
}


extension CLLocationCoordinate2D {
    static let shinjukuStation =
    CLLocationCoordinate2D(latitude: 35.6896646, longitude: 139.6999667)
    static let jec =
    CLLocationCoordinate2D(latitude: 35.6982316, longitude: 139.6981199)
}



#Preview {
    ContentView()
}
