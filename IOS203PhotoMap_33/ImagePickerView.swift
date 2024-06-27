//
//  ImagePickerView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/18.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    // UIImagePickerControllerが表示されているか管理
    @Binding var isShowSheet: Bool
    // 撮影した写真を格納する変数
    @Binding var captureImage: UIImage? // UIImage: 画像を管理するクラス
    class Coordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate {
        
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        // 撮影が終わった時に呼ばれるdelegateメソッド。実装必須
        internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                   info: [UIImagePickerController.InfoKey: Any]) {
            
            // 撮影した写真をcaptureImageに保存する
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originalImage
            }
            // Sheet閉じる
            parent.isShowSheet.toggle()
        }
        
        // キャンセル時に呼ばれるdelegateメソッド。実装必須
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Sheet閉じる
            parent.isShowSheet.toggle()
        }
    }
    
    // Coordinatorを生成する。SwiftUIが自動で呼ぶ
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Viewを生成した時に実行される
    func makeUIViewController(context: Context) -> some UIViewController {
        // UIImagePickerControllerのインスタンスを生成
        let imagePickerController = UIImagePickerController()
        // sourceTypeにcameraを設定する
        imagePickerController.sourceType = .camera
        // delegateの設定
        imagePickerController.delegate = context.coordinator
        // UIImagePickerControllerを返す
        return imagePickerController
    }
    
    // Viewが更新されたときに実行される
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 更新された時の処理を書く
    }
}
