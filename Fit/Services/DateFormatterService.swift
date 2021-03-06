

import Foundation

public class DateFormatterService {
    static let instance = DateFormatterService()
    
    public func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        let date = formatter.string(from: date)
        
        return date
    }
}
