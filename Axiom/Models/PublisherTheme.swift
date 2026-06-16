import SwiftUI

struct PublisherTheme {
    let color: Color
    let initials: String

    static func of(_ publisher: String) -> PublisherTheme {
        switch publisher {
        case "MIT Review":      return PublisherTheme(color: Color(red: 0.64, green: 0.12, blue: 0.20), initials: "MR")
        case "The Economist":   return PublisherTheme(color: Color(red: 0.80, green: 0.00, blue: 0.00), initials: "TE")
        case "Swift Blog":      return PublisherTheme(color: Color(red: 0.94, green: 0.32, blue: 0.22), initials: "SB")
        case "Space.com":       return PublisherTheme(color: Color(red: 0.11, green: 0.17, blue: 0.29), initials: "SC")
        case "Bloomberg":       return PublisherTheme(color: Color(red: 0.10, green: 0.10, blue: 0.10), initials: "BG")
        case "Wired":           return PublisherTheme(color: Color(red: 0.13, green: 0.13, blue: 0.13), initials: "WD")
        case "BBC":             return PublisherTheme(color: Color(red: 0.73, green: 0.10, blue: 0.10), initials: "BB")
        case "Reuters":         return PublisherTheme(color: Color(red: 0.85, green: 0.33, blue: 0.10), initials: "RE")
        case "NRC":             return PublisherTheme(color: Color(red: 0.10, green: 0.23, blue: 0.36), initials: "NR")
        case "De Telegraaf":    return PublisherTheme(color: Color(red: 0.00, green: 0.20, blue: 0.48), initials: "DT")
        case "NU.nl":           return PublisherTheme(color: Color(red: 0.95, green: 0.35, blue: 0.00), initials: "NU")
        case "The Guardian":    return PublisherTheme(color: Color(red: 0.02, green: 0.16, blue: 0.38), initials: "GU")
        case "DW":              return PublisherTheme(color: Color(red: 0.00, green: 0.42, blue: 0.70), initials: "DW")
        case "AP News":         return PublisherTheme(color: Color(red: 0.70, green: 0.07, blue: 0.07), initials: "AP")
        case "Al Jazeera":      return PublisherTheme(color: Color(red: 0.89, green: 0.12, blue: 0.17), initials: "AJ")
        case "TechCrunch":      return PublisherTheme(color: Color(red: 0.04, green: 0.48, blue: 0.33), initials: "TC")
        case "The Verge":       return PublisherTheme(color: Color(red: 0.90, green: 0.21, blue: 0.21), initials: "TV")
        case "Financial Times": return PublisherTheme(color: Color(red: 0.62, green: 0.28, blue: 0.08), initials: "FT")
        case "Le Monde":        return PublisherTheme(color: Color(red: 0.10, green: 0.10, blue: 0.10), initials: "LM")
        case "Nature":          return PublisherTheme(color: Color(red: 0.11, green: 0.31, blue: 0.45), initials: "NA")
        default:
            return PublisherTheme(color: .accentColor, initials: String(publisher.prefix(2).uppercased()))
        }
    }
}
