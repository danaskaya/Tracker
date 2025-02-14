//
//  WeekDay.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 11.02.2025.
//

import UIKit
enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
        case tuesday = "Вторник"
        case wednesday = "Среда"
        case thursday = "Четверг"
        case friday = "Пятница"
        case saturday = "Суббота"
        case sunday = "Воскресенье"

    var shortTitle: String {
        switch self {
            
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}
