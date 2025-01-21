import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)

        RegisterGeneratedPlugins(registry: flutterViewController)

        let registrar = flutterViewController.registrar(forPlugin: "bevy")
        let factory = FLNativeViewFactory(messenger: registrar.messenger, frame: windowFrame)
        registrar.register(factory, withId: "bevy_view")

        super.awakeFromNib()
    }
}
