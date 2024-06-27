//
//  ActivityView.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/24.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    
    let shareItems: [Any]
    
    // View生成時に実行される
    func makeUIViewController(context: Context) -> some UIViewController {
        // シェアする機能を生成
        let controller = UIActivityViewController(
            activityItems: shareItems,
            applicationActivities: nil
            )
        
        return controller
    }
    
    // View更新時に実行される
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
