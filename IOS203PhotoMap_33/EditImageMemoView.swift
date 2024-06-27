//
//  EditImageMemoView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/26.
//

import SwiftUI
import PhotosUI

struct EditImageMemoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var photoSpot: PhotoSpot
    @State private var title: String = ""
    @State private var comment: String = ""
    @State private var imageData: Data? = nil
    @State private var uiImage: UIImage?
    @State var selectedItem: PhotosPickerItem?
    @State private var camera = false
    @State private var currentLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing){
                TextField("タイトル", text: $title)
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
                        
                    } else if let data = photoSpot.imageData, let img = UIImage(data: data) {
                        Image(uiImage: img)
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
                    })
                    
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { saveChanges() }) {
                            Text("保存")
                        }
                    }
                }
            }
            .onAppear {
                title = photoSpot.title ?? ""
                comment = photoSpot.comment ?? ""
                imageData = photoSpot.imageData
            }
        }
    }
    
    private func saveChanges() {
        photoSpot.title = title
        photoSpot.comment = comment
        if let data = imageData {
            photoSpot.imageData = data
        } else if let uiImage = uiImage {
            photoSpot.imageData = uiImage.pngData()
        }
        photoSpot.updatedAt = Date()
        photoSpot.latitude = currentLocation?.latitude ?? 0.0
        photoSpot.longitude = currentLocation?.longitude ?? 0.0
        
        do {
            try viewContext.save()
            print("Changes saved successfully!")
        } catch {
            print(error)
        }
        
        dismiss()
        
    }
}

#Preview {
    EditImageMemoView(photoSpot: .constant(PhotoSpot()))
}
