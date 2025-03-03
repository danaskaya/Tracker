//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Diliara Sadrieva on 26.02.2025.
//
import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testLightViewController() {
            let vc = UINavigationController(rootViewController: TabBarController())
            
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        }
    
    func testDarkViewController() {
        let vc = UINavigationController(rootViewController: TabBarController())
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}
