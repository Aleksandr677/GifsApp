//
//  GifsController.swift
//  iOS Dev Test Project (UI)
//
//  Created by Христиченко Александр on 2023-01-26.
//

import SwiftUI
import GiphyUISDK

struct GifsController: UIViewControllerRepresentable {
    
    //PROPERTIES
    @Binding var url: String
    @Binding var isSheetPresented: Bool
    
    //Delegate functions
    func makeUIViewController(context: Context) -> GiphyViewController {
        //Insert your API key
        Giphy.configure(apiKey: "5oQ7meZKpSBgY4xTJfS0LL1exz36VZ4c")
        
        //Create instance of GiphyViewController
        let controller = GiphyViewController()
        controller.mediaTypeConfig = [.gifs, .emoji, .stickers, .text, .recents] //Customize to your own taste
        controller.delegate = context.coordinator
        GiphyViewController.trayHeightMultiplier = 1.05 //Default 0.7
        controller.theme = GPHTheme(type: .light)
        
        //May apply some extra modifiers
        //controller.modalPresentationStyle = .overCurrentContext
        //controller.swiftUIEnabled = true
        //controller.stickerColumnCount = GPHStickerColumnCount.three
        //controller.rating = .unrated
        //controller.showConfirmationScreen = true
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: GiphyViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return GifsController.Coordinator(parentController: self)
    }
    
    class Coordinator: NSObject, GiphyDelegate {
        
        var parentController: GifsController
        
        init(parentController: GifsController) {
            self.parentController = parentController
        }
        
        //when user taps on a gif
        func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
            if let url = media.url(rendition: .fixedWidth, fileType: .gif) {
                parentController.url = url
                parentController.isSheetPresented.toggle()
            }
        }
        
        func didDismiss(controller: GiphyUISDK.GiphyViewController?) { } //Customize to your own taste
    }
}
