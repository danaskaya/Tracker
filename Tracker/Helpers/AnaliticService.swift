//
//  AnaliticService.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 25.02.2025.
//
import Foundation
import YandexMobileMetrica


final class AnaliticService {
    
    //static func activate() {
   //     guard let configuration = YMMYandexMetricaConfiguration(apiKey: "3ad628e5-fb95-4a99-b8f3-743b31682a4b") else { return }
        
      //  YMMYandexMetrica.activate(with: configuration)
  //  }
    
    
    static func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

