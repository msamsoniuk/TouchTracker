//
//  TrackPointView.swift
//  
//
//  Created by p-x9 on 2023/04/12.
//  
//

import SwiftUI

struct TouchPointView: View {
    let location: CGPoint
    let radius: CGFloat

    var color: Color

    var isBordered: Bool
    var borderColor: Color
    var borderWidth: CGFloat

    var isDropShadow: Bool
    var shadowColor: Color
    var shadowRadius: CGFloat
    var shadowOffset: CGPoint

    var image: Image?

    var isShowLocation: Bool

    // Novo parâmetro para controlar a cruz de mira
    var isCrosshair: Bool
    var crosshairColor: Color
    var crosshairWidth: CGFloat
    //-----

    var locationText: some View {
        let x = String(format: "%.1f", location.x)
        let y = String(format: "%.1f", location.y)

        return Text("x: \(x)\ny: \(y)")
            .font(.system(size: 10))
            .lineLimit(2)
            .frame(maxWidth: .infinity)
    }

    var body: some View {
        color
            .frame(width: radius * 2, height: radius * 2)
            .cornerRadius(radius)
            .when(isBordered) {
                $0.overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            }
            .whenLet(image) {
                $0.overlay($1)
            }
            .when(isDropShadow) {
                $0.shadow(
                    color: shadowColor,
                    radius: shadowRadius,
                    x: shadowOffset.x,
                    y: shadowOffset.y
                )
            }
            .when(isShowLocation) {
                $0.overlay(
                    HStack(alignment: .center) {
                        locationText
                            .fixedSize()
                    }
                        .position(x: radius, y: -16 - shadowRadius)
                )
            }
            //-----
            .when(isCrosshair) {
                $0.overlay(
                    // Desenha a cruz de mira
                    ZStack {
                        // Linha horizontal
                        Rectangle()
                            .fill(crosshairColor)
                            .frame(width: radius * 2, height: crosshairWidth)
                        // Linha vertical
                        Rectangle()
                            .fill(crosshairColor)
                            .frame(width: crosshairWidth, height: radius * 2)
                    }
                )
            }
            //------
    }
}
