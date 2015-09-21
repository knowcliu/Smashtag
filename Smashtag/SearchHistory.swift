//
//  SearchHistory.swift
//  Smashtag
//
//  Created by Caroline Liu on 2015-09-19.
//  Copyright (c) 2015 Caroline Liu. All rights reserved.
//

import Foundation

class SearchHistory {
    
    static let sharedHistory = SearchHistory()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    struct UserDefaultsKeys {
        static let SearchHistory = "last100Searches"
    }
    
    var last100Searches: [String] {
        get {
            return defaults.objectForKey(UserDefaultsKeys.SearchHistory) as? [String] ?? [String]()
        }
        set {
            defaults.setObject(newValue, forKey: UserDefaultsKeys.SearchHistory)
        }
    }
    
    func addSearchTerm(searchTerm: String) {
        // store the last 100 search terms
        if last100Searches.count > 100 {
            last100Searches.removeAtIndex(0)
        }
        
        last100Searches.append(searchTerm)
        debugPrint("Added search to history: \(searchTerm)")
    }
}
