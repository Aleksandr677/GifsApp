//
//  Home.swift
//  iOS Dev Test Project (UI)
//
//  Created by Христиченко Александр on 2023-01-26.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    //MARK: - PROPERTIES
    @State private var gifsArray: [String]  = []
    @State private var isSheetPresented: Bool = false
    @State private var urlImage: String = ""
    @State private var animatingButton: Bool = false
    private var image: UIImage? = nil
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            gifsLayer
                .navigationTitle("My Gifs")
                .navigationBarTitleDisplayMode(.large)
                .overlay(alignment: .bottomTrailing) {
                    overlayButton
                }
        } //Navigation
        .background(.ultraThickMaterial)
        .fullScreenCover(isPresented: $isSheetPresented) {
            GifsController(url: $urlImage, isSheetPresented: $isSheetPresented)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//MARK: - PREVIEW
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: - COMPONENTS
extension Home {
    //Overlay button
    private var overlayButton: some View {
        ZStack {
            Group {
                Circle()
                    .fill(Color.blue)
                    .opacity(animatingButton ? 0.2 : 0)
                    .scaleEffect(animatingButton ? 1 : 0)
                    .frame(width: 68, height: 68, alignment: .center)
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                
                Circle()
                    .fill(Color.blue)
                    .opacity(animatingButton ? 0.15 : 0)
                    .scaleEffect(animatingButton ? 1 : 0)
                    .frame(width: 88, height: 88, alignment: .center)
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
            } //Group
            .animation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true),
                value: animatingButton)
            
            Button {
                isSheetPresented.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .background(Circle().fill(Color(.giphyPink).opacity(0.5)))
                    .frame(width: 48, height: 48, alignment: .center)
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
            } //Button
            .onAppear {
                animatingButton.toggle()
            } //OnAppear
        } //ZStack
    }
    
    //Gifs layer
    private var gifsLayer: some View {
        ScrollView(showsIndicators: false) {
            RoundedRectangle(cornerRadius: 1)
                .frame(height: 1)
                .foregroundColor(Color.blue.opacity(0.3))
            ForEach(gifsArray, id: \.self) { url in
                VStack(alignment: .center, spacing: 10) {
                    NavigationLink(destination: { GifDetailView(url: url) }) {
                        AnimatedImage(url: URL(string: url))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(CustomGifShape())
                            .contextMenu {
                                VStack {
                                    //Save to photo
                                    Button(action: {
                                        self.saveGIF(url: url)
                                    }, label: {
                                        HStack(spacing: 5) {
                                            Text("Save to photos")
                                            Image(systemName: "menubar.arrow.down.rectangle")
                                        }
                                        .padding(3)
                                        .font(.title3)
                                    }) //Button
                                    
                                    //Copy gif's url
                                    Button(action: {
                                        self.saveUrlToClipBoard(url: url)
                                    }, label: {
                                        HStack(spacing: 5) {
                                            Text("Copy link")
                                            Image(systemName: "doc.on.doc")
                                        }
                                        .padding(3)
                                        .font(.title3)
                                    }) //Button
                                } //VStack
                        } //ContextMenu
                    } //NavigationLink
                
                    //Divider
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height: 1)
                        .foregroundColor(Color.blue.opacity(0.3))
                } //VStack
                .padding(.horizontal)
            } //Loop
            .onChange(of: urlImage, perform: { newValue in
                self.gifsArray.append(newValue)
            })
        } //Scroll
    }
}

//MARK: - FUNCTIONS
extension Home {
    //Save GIF to the library
    private func saveGIF(url: String) {
        if let url = URL(string: url) {
            DownloadGif.shared.downloadGif(from: url)
        }
    }
    
    //Save link to the clipboard
    private func saveUrlToClipBoard(url: String) {
        UIPasteboard.general.string = url
    }
}

