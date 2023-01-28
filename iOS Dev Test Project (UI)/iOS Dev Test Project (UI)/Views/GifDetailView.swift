//
//  GifDetailView.swift
//  iOS Dev Test Project (UI)
//
//  Created by Христиченко Александр on 2023-01-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct GifDetailView: View {
    //MARK: - PROPERTIES
    let url: String
    @Environment(\.dismiss) private var dismiss
    @State private var isAlertPresented: Bool = false
    var image: UIImage = UIImage()
    
    //MARK: - BODY
    var body: some View {
        VStack {
            //Header
            headerButtons
            
            //Gif
            gifLayer
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .background(.ultraThickMaterial)
        .sheet(isPresented: $isAlertPresented) {
            alertContent
        }
    }
}

//MARK: - PREVIEW
struct GifDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GifDetailView(url:"https://media3.giphy.com/media/gl8ymnpv4Sqha/200w.gif?cid=2976c73dmskzm4075b98s8cv4pwbjcf0ft9tt0t85nx9tztz&rid=200w.gif&ct=g")
    }
}

//MARK: - COMPONENTS
extension GifDetailView {
    
    //Header buttons
    private var headerButtons: some View {
        HStack {
            //Close button
            Button(
                action: {
                    dismiss.callAsFunction()
                },
                label: {
                    Image(systemName: "xmark.circle")
                }) //Button
            
            Spacer()
            
            //Alert button
            Button(
                action: {
                    isAlertPresented.toggle()
                },
                label: {
                    Image(systemName: "square.and.arrow.up")
                }) //Button
        } //HStack
        .font(.title)
        .foregroundColor(Color.blue)
        .padding()
    }
    
    //Gif image
    private var gifLayer: some View {
        AnimatedImage(url: URL(string: url))
            .aspectRatio(contentMode: .fit)
    }
    
    //Alert content
    private var alertContent: some View {
        VStack(alignment: .center, spacing: 10) {
            //Save to photo
            Button(action: {
                self.saveGif()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAlertPresented = false
                }
            }, label: {
                Text("Save to photos")
                    .padding(3)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.blue.opacity(0.8))
                    }
            }) //Button
            
            //Copy gif
            Button(action: {
                copyGifToClipBoard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAlertPresented = false
                }
            }, label: {
                Text("Copy GIF")
                    .padding(3)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.blue.opacity(0.8))
                    }
            }) //Button
            
            //Copy gif's url
            Button(action: {
                self.copyUrlToClipBoard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAlertPresented = false
                }
            }, label: {
                Text("Copy GIF's link")
                    .padding(3)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.blue.opacity(0.8))
                    }
            }) //Button
            
            //Cancel button
            Button(action: {
                self.isAlertPresented = false
            }, label: {
                Text("Cancel")
                    .padding(3)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.3))
                    }
            }) //Button
        } //VStack
        .padding(.horizontal)
        .presentationDetents([.height(220), .medium])
    }
}

//MARK: - FUNCTIONS
extension GifDetailView {
    //Save gif to the library
    private func saveGif() {
        if let url = URL(string: url) {
            DownloadGif.shared.downloadGif(from: url)
        }
    }
    
    //Copy link to the clipboard
    private func copyUrlToClipBoard() {
        UIPasteboard.general.string = url
    }
    
    //Copy image to the clipboard
    private func copyGifToClipBoard() {
        if let url = URL(string: url) {
            DownloadGif.shared.copyGif(from: url)
        }
    }
}
