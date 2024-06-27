//
//  MemoPageView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/26.
//

import SwiftUI
import CoreData

struct MemoPageView: View {
    
    @State private var selectedPhotoSpot: PhotoSpot?
    @StateObject var geoapi = GeoApi()
    var photoSpot: PhotoSpot
    var body: some View {
        VStack {
            if let imageData = photoSpot.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 300)
            } else {
                Image("noImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 300)
            }
            
            Text("期日: \(photoSpot.stringUpdatedAt)")
                .font(.caption)
                .padding()
            
            Text(photoSpot.comment ?? "")
                .font(.body)
                .foregroundColor(.brown)
            
            Spacer()
            
            if let location = geoapi.location.first {
                HStack(alignment: .center) {
                    Text(location.city)
                    Text(location.town)
                }
                .font(.caption)
            }
        }
                .onAppear {
                    if photoSpot.longitude != 0.0 && photoSpot.latitude != 0.0 {
                        Task {
                            await geoapi.getlocation(x: photoSpot.longitude              ,y: photoSpot.latitude)
                        }
                    } else {
                        print("error")
                    }
                }
               .navigationTitle(photoSpot.title ?? "No Title")
               .navigationBarTitleDisplayMode(.inline)
    }
}

func createSamplePhotoSpot() -> PhotoSpot {
    let context = PersistenceController.preview.container.viewContext
    let photoSpot = PhotoSpot(context: context)
    photoSpot.title = "Sample Title"
    photoSpot.comment = "Sample Comment"
    photoSpot.createdAt = Date()
    photoSpot.updatedAt = Date()
    photoSpot.latitude = 35.6982316
    photoSpot.longitude = 139.6981199
    if let image = UIImage(systemName: "photo"), let imageData = image.pngData() {
        photoSpot.imageData = imageData
    }
    return photoSpot
}


#Preview {
    MemoPageView(photoSpot: createSamplePhotoSpot())
}
