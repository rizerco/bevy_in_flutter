//
//  ViewController.swift
//  bevy_in_iOS
//
//  Created by Jinlei Li on 2022/12/20.
//

import CoreMotion
import UIKit

class ViewController: UIViewController {
    @IBOutlet var metalV: MetalView!
    var bevyApp: OpaquePointer?

    var rotationRate: CMRotationRate?
    var gravity: CMAcceleration?
    lazy var motionManager: CMMotionManager = {
        let manager = CMMotionManager()
        manager.gyroUpdateInterval = 0.032
        manager.accelerometerUpdateInterval = 0.032
        manager.deviceMotionUpdateInterval = 0.032
        return manager
    }()

    lazy var displayLink: CADisplayLink = .init(target: self, selector: #selector(enterFrame))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.displayLink.add(to: .current, forMode: .default)
        self.displayLink.isPaused = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .white
        if self.bevyApp == nil {
            self.createBevyApp()
        }
        self.displayLink.isPaused = false
        self.startDeviceMotionUpdates()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.displayLink.isPaused = true
        self.stopDeviceMotionUpdates()
    }

    func createBevyApp() {
        let viewPointer = Unmanaged.passUnretained(self.metalV).toOpaque()
        let maximumFrames = Int32(UIScreen.main.maximumFramesPerSecond)
        self.bevyApp = create_bevy_app(viewPointer, maximumFrames, Float(UIScreen.main.nativeScale))
    }

    @IBAction func recreateBevyApp() {
        if let bevy = bevyApp {
            self.displayLink.isPaused = true
            release_bevy_app(bevy)
        }

        self.createBevyApp()
        self.displayLink.isPaused = false
    }

    @objc func enterFrame() {
        guard let bevy = self.bevyApp else {
            return
        }
        // call rust
        if let gravity = gravity {
            device_motion(bevy, Float(gravity.x), Float(gravity.y), Float(gravity.z))
        }
        enter_frame(bevy)
    }

    // MARK: touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV)
            touch_started(bevy, Float(location.x), Float(location.y))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV)
            touch_moved(bevy, Float(location.x), Float(location.y))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV)
            touch_ended(bevy, Float(location.x), Float(location.y))
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV)
            touch_cancelled(bevy, Float(location.x), Float(location.y))
        }
    }

    deinit {
        if let bevy = bevyApp {
            release_bevy_app(bevy)
        }
    }
}
