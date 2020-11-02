import Cocoa

class ViewController: NSViewController {

    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet weak var summaryTextField: NSTextField!
    @IBOutlet weak var locationTextField: NSTextField!
    @IBOutlet weak var datePicker: NSDatePicker!
    @objc dynamic var entries : [Event] = []
    
    override func viewDidLoad() {
        datePicker.dateValue = Date()
    }
    
    @IBAction func addEntryAction(_ sender: Any) {
        let event = Event()
        event.summary = summaryTextField.stringValue
        event.location = locationTextField.stringValue
        event.date = datePicker.dateValue
        arrayController.addObject(event)
    }
    
    @IBAction func exportAsICSAction(_ sender: Any) {
       
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["ics"]
        guard let window = view.window else { return }
        panel.beginSheetModal(for: window) { [weak self] (response) in
            if response == .OK {
                if let url = panel.url {
                    try? self?.icsContent().data(using: .utf8)?.write(to: url)
                }
            }
        }
    }
    
    @IBAction func removeEntryAction(_ sender: Any) {
        arrayController.remove(self)
    }
    
    func icsContent() -> String  {
        var text = "BEGIN:VCALENDAR" + "\r\n"
        text += "VERSION:2.0" + "\r\n"
        text += "PRODID:iQR Codes" + "\r\n"
        text += "CALSCALE:GREGORIAN" + "\r\n"
        for entry in entries {
            text += entry.icsText()
        }
        text += "END:VCALENDAR" + "\r\n"
        return text
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        guard let controller = segue.destinationController as? QRViewController else {
            fatalError("Missing QRViewController")
        }
        controller.text = icsContent()
    }
}

