//
//  AddImageMemoView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/21.
//

import SwiftUI
import PhotosUI

struct AddImageMemoView: View {
    
    @Environment(\.managedObjectContext)private var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var comment: String = ""
    @State private var imageData: Data? = nil
    @State var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @State private var uiImage: UIImage?
    @State private var camera = false
    @State private var currentLocation: CLLocationCoordinate2D?
    @StateObject private var locationmanager = LocationManager()
    
    var latitude: Double {
        locationmanager.currentLocation?.coordinate.latitude ?? 0
    }
    
    var longitude: Double {
        locationmanager.currentLocation?.coordinate.longitude ?? 0
    }
    
    var body: some View {
        VStack(alignment: .trailing){
            TextField("タイトル",text: $title)
                .font(.title)
                .border(.pink)
            TextEditor(text: $comment)
                .font(.body)
                .border(.brown)
            
            HStack {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
               
                } else {
                    Image("noImage")
                        .font(.system(size: 50))
                        .frame(width: 100, height: 100)
                }
                
                PhotosPicker(selection: $selectedItem) {
                    Image(systemName: "photo.artframe.circle")
                        .font(.system(size: 45))
                }
                .onChange(of: selectedItem) { oldvalue, newItem in
                    Task {
                        guard let data = try? await newItem?.loadTransferable(type: Data.self) else { return }
                        guard let uiImage = UIImage(data: data) else { return }
                        imageData = data
                        self.uiImage = uiImage
                    }
                }
                Spacer()
                
                Button(action: {
                    camera = true
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 30))
                })
                .sheet(isPresented: $camera, content: {
                    CameraView(captureImage: $uiImage, isShowSheet: $camera, currentLocation: $currentLocation)
                        .onDisappear {
                                self.selectedItem = PhotosPickerItem(itemIdentifier: UUID().uuidString)
                        }
                })
                    
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {addImageMemo()}) {
                            Text("保存")
                        }
                    }
                }
            }
        }
    
    //保存ボタンを押下ときの処理
    private func addImageMemo(){
        let imageMemo = PhotoSpot(context: viewContext)
        //        let image = UIImage(named: "1") //仮データ
        
        imageMemo.title = title
        imageMemo.comment = comment
        imageMemo.imageData = imageData ?? uiImage?.pngData()
        imageMemo.createdAt = Date()
        imageMemo.updatedAt = Date()
        imageMemo.latitude = locationmanager.currentLocation?.coordinate.latitude ?? 0.0
        imageMemo.longitude = locationmanager.currentLocation?.coordinate.longitude ?? 0.0
        
        do {
            try viewContext.save()
            print("Image memo saved successfully!")
        } catch {
            print(error)
        }
        
        dismiss()
    }
}


#Preview {
    AddImageMemoView()
}
