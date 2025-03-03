//
//  WeekDay.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 22.02.2025.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var shortTitle: String {
        switch self {
            
        case .monday:
            return NSLocalizedString("shortMonday", comment: "")
        case .tuesday:
            return NSLocalizedString("shortTuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("shortWednesday", comment: "")
        case .thursday:
            return NSLocalizedString("shortThursday", comment: "")
        case .friday:
            return NSLocalizedString("shortFriday", comment: "")
        case .saturday:
            return NSLocalizedString("shortSaturday", comment: "")
        case .sunday:
            return NSLocalizedString("shortSunday", comment: "")
        }
    }
}
