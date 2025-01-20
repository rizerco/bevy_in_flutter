import Cocoa
import FlutterMacOS

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var _viewController = ViewController()
    private var messenger: FlutterBinaryMessenger
    private var frame: NSRect

    init(messenger: FlutterBinaryMessenger, frame: NSRect) {
        self.messenger = messenger
        self.frame = frame
        super.init()
    }

    // Correct method name as per the protocol
    func create(withViewIdentifier viewId: Int64, arguments args: Any?) -> NSView {
        _viewController.loadView()
        _viewController.viewDidLoad()
        _viewController.view.frame = frame
        return _viewController.view
    }

    // Correct return type for protocol conformance
    func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
