import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    @IBOutlet weak var window: NSWindow!
    var viewController: ViewController?

    override func applicationDidFinishLaunching(_ notification: Notification) {
        super.applicationDidFinishLaunching(notification)
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
