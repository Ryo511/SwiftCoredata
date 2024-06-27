//
//  CameraView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/24.
//

import SwiftUI
import PhotosUI

struct CameraView: View {
    
    // 撮影した写真を保持する状態変数
    @Binding var captureImage: UIImage?
    // 撮影画面(sheet)の開閉状態を管理
    @Binding var isShowSheet: Bool
    @State var isShowActivity = false
    @State var isPhotoLibrary = false
    @State var selectedItem: PhotosPickerItem?
    @Binding var currentLocation: CLLocationCoordinate2D?
    @ObservedObject var locationmanager = LocationManager()

    @State var isShowAction = false
    @State private var title: String = ""
    @State private var comment: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        if let image = captureImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        
        Spacer()
        
            .onAppear {
                isShowSheet = true
                locationmanager.manager.requestWhenInUseAuthorization()
                locationmanager.manager.startUpdatingLocation()
            }
        // isShowSheetがtrueのときにsheetを表示する
            .sheet(isPresented: $isShowSheet) {
                // UIImagePickerController (撮影画面)を表示する
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            .onDisappear {
                
                    currentLocation = locationmanager.currentLocation?.coordinate
                
            }
            .padding()
        
        
    }
//    private func saveImageToCoreData(image: UIImage) {
//        if let imageData = image.jpegData(compressionQuality: 1.0) {
//            let newMemo = PhotoSpot(context: viewContext)
//            newMemo.title = title
//            newMemo.comment = comment
//            newMemo.imageData = imageData
//            newMemo.createdAt = Date()
//            newMemo.updatedAt = Date()
//            
//            try? viewContext.save()
//        }
//    }
}

#Preview {
    AddImageMemoView()
}
