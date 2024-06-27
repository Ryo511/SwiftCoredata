//
//  MemoList.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/22.
//

import SwiftUI

struct MemoList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PhotoSpot.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)],
                  animation: .default) var fetchedPhotoSpotList: FetchedResults<PhotoSpot>
    @State private var selectedPhotoSpot: PhotoSpot?
    @StateObject var geoapi = GeoApi()
    var body: some View {
        NavigationStack {
            List {
                ForEach(fetchedPhotoSpotList) { photospot in
                    NavigationLink(destination: MemoPageView(photoSpot: photospot)) {
                        VStack {
                            if let imageData = photospot.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                            } else {
                                Image("noImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                            }
                            
                            Text(photospot.title ?? "")
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            HStack {
                                Text(photospot.stringUpdatedAt)
                                    .font(.caption)
                                    .lineLimit(1)
                                Text(photospot.comment ?? "")
                                    .font(.caption)
                                    .lineLimit(1)
                                Spacer()
                            }
                            
                            if let location = geoapi.location.first {
                                HStack {
                                    Text(location.city)
                                    Text(location.town)
                                }
                                .font(.caption)
                            } else {
                                Text("Loading Location...")
                                    .font(.caption)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPhotoSpot = photospot
                        }
                        .onAppear {
                            if photospot.longitude != 0.0 && photospot.latitude != 0.0 {
                                Task {
                                    await geoapi.getlocation(x: photospot.longitude,
                                                             y: photospot.latitude)
                                }
                            } else {
                                print("Invalid coordinates for PhotoSpot \(photospot.title ?? "Unknown")")
                            }
                        }
                    }
                }
                .onDelete { indexset in
                    for index in indexset {
                        let photospot = fetchedPhotoSpotList[index]
                        viewContext.delete(photospot)
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
            .navigationTitle("メモ")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                EditButton()
            }
        }
        .sheet(item: $selectedPhotoSpot) { PhotoSpot in
            EditImageMemoView(photoSpot: .constant(PhotoSpot))
        }
    }
}

#Preview {
    MemoList()
}
