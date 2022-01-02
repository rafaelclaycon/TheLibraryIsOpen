import Foundation

extension Date {

    func asDMYString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }

    // Possibilities for dateStyle: .short, .medium, .long, .full
    func asFullString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> String {
        return String(calendar.component(component, from: self))
    }

}

extension Double {

    func toDisplayString() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60

        // Less than a minute
        if totalSeconds < 60 {
            return String(format: "%1ds", seconds)
            // Less than an hour
        } else if totalSeconds < 3600 {
            // If "whole" minutes
            if (totalSeconds % 60) < 60 {
                return String(format: "%1dm", minutes)
            } else {
                return String(format: "%1dm %1ds", minutes, seconds)
            }
        } else {
            // If "whole" hours
            if (totalSeconds % 3600) < 60 {
                return String(format: "%1dh", hours)
            } else {
                return String(format: "%1dh %1dm", hours, minutes)
            }
        }
    }

}
