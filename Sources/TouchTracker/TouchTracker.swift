import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// A view to display a mark on a touched point in a SwiftUI View
///
/// It can be used in the following two ways.
/// - Wrap the content with this view
///  ```swift
///  TouchTrackingView {
///    Text("Content View")
///  }
///  ```
/// - Use modifier of SwiftUI.View
///  ```swift
///  Text("Content View")
///      .touchTrack()
///  ```
@available(macOS, unavailable)
@available(iOS 13.0, *)
public struct TouchTrackingView<Content: View>: View {
    let content: Content

    @State var locations: [CGPoint] = []
    @State var isCaptured: Bool = false

    var radius: CGFloat = 20
    var color: Color = .red

    var offset: CGPoint = .zero

    var isBordered: Bool = false
    var borderColor: Color = .black
    var borderWidth: CGFloat = 1

    var isDropShadow: Bool = true
    var shadowColor: Color = .black
    var shadowRadius: CGFloat = 3
    var shadowOffset: CGPoint = .zero

    var image: Image?

    var isShowLocation: Bool = false

    // Novos parâmetros para a cruz de mira
    var isCrosshair: Bool = false
    var crosshairColor: Color = .black
    var crosshairWidth: CGFloat = 1
    ///-----

    var displayMode: DisplayMode = .always

    public init(_ content: Content) {
        self.content = content
#if canImport(UIKit)
        UIWindow.hook()
#endif
    }

    public init(_ content: () -> Content) {
        self.init(content())
    }

    var touchPointsView: some View {
        ForEach(0..<locations.count, id: \.self) { index in
            let location = locations[index]
            TouchPointView(
                location: location,
                radius: radius,
                color: color,
                isBordered: isBordered,
                borderColor: borderColor,
                borderWidth: borderWidth,
                isDropShadow: isDropShadow,
                shadowColor: shadowColor,
                shadowRadius: shadowRadius,
                shadowOffset: shadowOffset,
                image: image,
                isShowLocation: isShowLocation,
                //-----
                isCrosshair: isCrosshair, // Novo parâmetro
                crosshairColor: crosshairColor, // Novo parâmetro
                crosshairWidth: crosshairWidth // Novo parâmetro
                //----
            )
            .position(x: location.x + offset.x, y: location.y + offset.y)
            .allowsHitTesting(false)
        }
        .allowsHitTesting(false)
    }

    public var body: some View {
        content
#if canImport(UIKit)
            .hidden()
            .background(
                ZStack {
                    TouchLocationView($locations, isCaptured: $isCaptured) {
                        content
                    }
                    if displayMode.shouldDisplay(captured: isCaptured){
                        touchPointsView
                            .zIndex(.infinity)
                    }
                }
            )
#endif
    }
}

@available(macOS, unavailable)
@available(iOS 13.0, *)
extension TouchTrackingView {
    /// radius of mark on touched point
    public func touchPointRadius(_ radius: CGFloat) -> Self {
        set(radius, for: \.radius)
    }

    /// color of mark on touched point
    public func touchPointColor(_ color: Color) -> Self {
        set(color, for: \.color)
    }

    /// offset of mark on touched point
    public func touchPointOffset(x: CGFloat = 0, y: CGFloat = 0) -> Self {
        set(.init(x: x, y: y), for: \.offset)
    }

    /// applying a border to touched points
    public func touchPointBorder(_ enabled: Bool, color: Color = .black, width: CGFloat = 1) -> Self {
        self
            .set(enabled, for: \.isBordered)
            .set(color, for: \.borderColor)
            .set(width, for: \.borderWidth)

    }

    /// shadow on touched points
    public func touchPointShadow(_ enabled: Bool, color: Color = .black, radius: CGFloat = 3, offset: CGPoint = .zero) -> Self {
        self
            .set(enabled, for: \.isDropShadow)
            .set(color, for: \.shadowColor)
            .set(radius, for: \.shadowRadius)
            .set(offset, for: \.shadowOffset)
    }

    /// show image on touched points
    public func touchPointImage(_ image: Image?) -> Self {
        set(image, for: \.image)
    }

    /// show touch coordinate
    public func showLocationLabel(_ enabled: Bool) -> Self {
        set(enabled, for: \.isShowLocation)
    }

    /// display mode of touched points.
    public func touchPointDisplayMode(_ mode: DisplayMode) -> Self {
        set(mode, for: \.displayMode)
    }

    /// Configura a cruz de mira nos pontos tocados
    public func touchPointCrosshair(_ enabled: Bool, color: Color = .black, width: CGFloat = 1) -> Self {
        self
            .set(enabled, for: \.isCrosshair)
            .set(color, for: \.crosshairColor)
            .set(width, for: \.crosshairWidth)
    }
    //------

    public func setTouchPointStyle(_ style: TouchPointStyle) -> Self {
        self
            .set(style.radius, for: \.radius)
            .set(style.color, for: \.color)
            .set(style.offset, for: \.offset)
            .set(style.isBordered, for: \.isBordered)
            .set(style.borderColor, for: \.borderColor)
            .set(style.borderWidth, for: \.borderWidth)
            .set(style.isDropShadow, for: \.isDropShadow)
            .set(style.shadowColor, for: \.shadowColor)
            .set(style.shadowRadius, for: \.shadowRadius)
            .set(style.shadowOffset, for: \.shadowOffset)
            .set(style.isShowLocation, for: \.isShowLocation)
            .set(style.displayMode, for: \.displayMode)

    }

    private func set<T>(_ value: T, for keyPath: WritableKeyPath<TouchTrackingView, T>) -> Self {
        var new = self
        new[keyPath: keyPath] = value
        return new
    }
}

struct TouchTrackingView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello")
            Button("Button") {
                print("tapped")
            }
        }
        .frame(width: 100, height: 100)
#if canImport(UIKit)
        .touchTrack()
        .touchPointRadius(8)
        .touchPointOffset(x: 0, y: -10)
        .touchPointColor(.orange)
        .touchPointBorder(true, color: .blue, width: 1)
        .touchPointShadow(true, color: .purple, radius: 3)
        .showLocationLabel(true)
#endif
    }
}
