//
//  InterceptURLUserDefault.swift
//  CocoaDebug
//
//  Created by N Aravindhan Natarajan on 03/11/23.
//

import Foundation
import UIKit

struct InterceptURLModel: Codable {
    var fromURL: String = ""
    var toURL: String = ""
}

struct InterceptURLUserDefault {
    
    fileprivate static func getDataToModel() -> [InterceptURLModel] {
        if let savedData = UserDefaults.standard.data(forKey: "intercept_urls") {
            let decoder = JSONDecoder()
            if let data = try? decoder.decode([InterceptURLModel].self, from: savedData) {
               return data
            }
        }
        return []
    }
    
    static func addInterceptURL(fromURL: String, toURL: String) {
        let model = InterceptURLModel(fromURL: fromURL, toURL: toURL)
        
        var oldValues: [InterceptURLModel] = InterceptURLUserDefault.getDataToModel()
        oldValues.append(model)
        
        
        let encoder = JSONEncoder()

        if let encodedData = try? encoder.encode(oldValues) {
            UserDefaults.standard.set(encodedData, forKey: "intercept_urls")
        }
    }
    
    static func getInterceptURLS() -> [InterceptURLModel] {
        return InterceptURLUserDefault.getDataToModel()
    }
    
    static func deleteInterceptURL(at index: Int) {
        var values = InterceptURLUserDefault.getDataToModel()
        values.remove(at: index)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(values) {
            UserDefaults.standard.set(encodedData, forKey: "intercept_urls")
        }
    }
    
}
