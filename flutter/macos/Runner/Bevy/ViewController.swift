// ViewController.swift
import Cocoa
import CoreGraphics

class ViewController: NSViewController {
    var metalView: MetalView?
    var bevyApp: OpaquePointer?

    private var displayLink: CVDisplayLink?

    private func setupDisplayLink() {
        var success = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard success == kCVReturnSuccess else {
            print("Failed to create display link")
            return
        }

        // Set the callback function
        success = CVDisplayLinkSetOutputCallback(
            displayLink!,
            { (displayLink, _, _, _, _, userInfo) -> CVReturn in
                let controller = Unmanaged<ViewController>.fromOpaque(userInfo!)
                    .takeUnretainedValue()
                DispatchQueue.main.async {
                    controller.enterFrame()
                }
                return kCVReturnSuccess
            }, Unmanaged.passUnretained(self).toOpaque())

        guard success == kCVReturnSuccess else {
            print("Failed to set display link callback")
            return
        }
    }

    // Start the display link
    private func startDisplayLink() {
        CVDisplayLinkStart(displayLink!)
    }

    // Stop the display link
    private func stopDisplayLink() {
        CVDisplayLinkStop(displayLink!)
    }

    override func loadView() {
        super.loadView()
        print("loadView")
        self.metalView = MetalView()
        self.setupDisplayLink()
        self.view = self.metalView!
        print(self.view.frame)
        print(self.view.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.wantsLayer = true
        if bevyApp == nil {
            self.createBevyApp()
        }
    }

    func createBevyApp() {
        print("createBevyApp")
        let viewPointer = Unmanaged.passUnretained(self.metalView!).toOpaque()
        let screen = NSScreen.main ?? NSScreen.screens.first
        let maximumFrames = Int32(30)  // macOS typically uses 60Hz, or you can detect the actual refresh rate
        let scale = Float(screen?.backingScaleFactor ?? 1.0)
        bevyApp = create_bevy_app(viewPointer, maximumFrames, scale)
        self.startDisplayLink()
    }

    @objc func enterFrame() {
        guard let bevy = self.bevyApp else {
            return
        }
        enter_frame(bevy)
    }

    deinit {
        if let bevy = bevyApp {
            release_bevy_app(bevy)
        }
        if let displayLink = displayLink {
            CVDisplayLinkStop(displayLink)
        }
    }
}
