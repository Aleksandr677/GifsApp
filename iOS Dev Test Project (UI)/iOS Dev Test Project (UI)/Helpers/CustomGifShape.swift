//
//  CustomGifShape.swift
//  iOS Dev Test Project (UI)
//
//  Created by Христиченко Александр on 2023-01-28.
//

import SwiftUI

struct CustomGifShape: Shape {
    //Shape for gifs
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}
