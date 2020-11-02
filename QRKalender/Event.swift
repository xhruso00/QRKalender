import Foundation


@objc
class Event : NSObject {
    @objc dynamic var date : Date = Date()
    @objc dynamic var summary : String = ""
    @objc dynamic var location : String = ""
    
    private static let stampDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd'T'HHmmss"
        return formatter
    }()
    
    private static let startDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    func icsText() -> String {
        var text = "BEGIN:VEVENT" + "\r\n"
        let dtstamp = Self.stampDateFormatter.string(from: Date())
        text += "DTSTAMP:\(dtstamp)" + "\r\n"
        text += "UID::\(UUID())" + "\r\n"
        let dtstart = Self.startDateFormatter.string(from: date)
        text += "DTSTART;VALUE=DATE:\(dtstart)" + "\r\n"
        text += "LOCATION:\(Self.sanitize(text: location))" + "\r\n"
        text += "SUMMARY:\(Self.sanitize(text: summary))" + "\r\n"
        text += "END:VEVENT" + "\r\n"
//        BEGIN:VEVENT
//        DTSTAMP:20190812T105011Z
//        UID:b22ec353-cf18-49fa-81e2-d222f7fb6d5a
//        DTSTART;VALUE=DATE:20200320
//        LOCATION:
//        SUMMARY:KGS Prüfungen: Abgabe Wahlzettel mdl. Prüfungen (Nebenfach)
//        END:VEVENT
        
        return text
    }
    
    
    
    static func sanitize(text : String) -> String {
        var sanitized = text.trimmingCharacters(in: .whitespaces) //deleting white spaces from begining and end
        sanitized = sanitized.components(separatedBy: .controlCharacters).joined() //removing control characters
        sanitized = sanitized.replacingOccurrences(of: "\\", with: #"\\"#)
        sanitized = sanitized.replacingOccurrences(of: ";", with: #"\;"#)
        sanitized = sanitized.replacingOccurrences(of: ",", with: #"\,"#)
        sanitized = sanitized.replacingOccurrences(of: "\n", with: #"\n"#)
        return sanitized
    }
}


