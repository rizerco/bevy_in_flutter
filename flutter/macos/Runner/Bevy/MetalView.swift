import Cocoa
import Metal

class MetalView: NSView {
    private var metalLayer: CAMetalLayer?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        print("MetalView:init")
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        configLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func makeBackingLayer() -> CALayer {
        let metalLayer = CAMetalLayer()
        self.metalLayer = metalLayer
        return metalLayer
    }

    private func configLayer() {
        print("MetalView:configLayer")
        guard let metalLayer = self.layer as? CAMetalLayer else {
            return
        }

        self.metalLayer = metalLayer
        metalLayer.presentsWithTransaction = false
        metalLayer.framebufferOnly = true

        let screen = NSScreen.main ?? NSScreen.screens.first
        self.layer?.contentsScale = screen!.backingScaleFactor
        metalLayer.contentsScale = screen!.backingScaleFactor
    }

    @objc func getSize() -> CGRect {
        let width = frame.width
        let height = frame.height

        return CGRect(
            x: 0.0, y: 0.0, width: width > 0 ? width : 800, height: height > 0 ? height : 800
        )
    }
}
