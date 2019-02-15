
import UIKit
import WebKit
import AudioToolbox

class PdfViewController: UIViewController{
    var magazine : Magazine!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var flashableView: FlashableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSURL(fileURLWithPath: Bundle.main.path(forResource: magazine.magazineName!, ofType: "pdf")!)
        let request = NSURLRequest(url: path as URL)
        webView.load(request as URLRequest)
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.setRightBarButton(bookmarkbutton, animated: true)
        self.becomeFirstResponder()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToShelfSegue" {
            if let destination = segue.destination as? ShelfListSelectionViewController {
                destination.magazine = magazine
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction private func favorite(_ sender: Any) {

    }
    
    @IBOutlet private var bookmarkbutton: UIBarButtonItem!

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            webView.takeSnapshot(with: nil) { (image, error) in
                guard error == nil else {
                    return
                }
                self.flashableView.flashView()
                if let image = image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                }
                let soundID : SystemSoundID = 1108;
                AudioServicesPlaySystemSoundWithCompletion(soundID, nil)
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
 
