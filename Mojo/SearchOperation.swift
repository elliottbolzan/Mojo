//
//  SearchOperation.swift
//  Mojo
//
//  Created by Elliott Bolzan on 11/26/15.
//  Copyright © 2015 Elliott Bolzan. All rights reserved.
//

import Cocoa

class SearchOperation: NSOperation {

    let searchString: String
    var emojiSet = Set<String>()
    let displayConstant = 48

    init(searchString: String) {
        self.searchString = searchString.lowercaseString
    }

    override func main() {
        if self.cancelled {
            return
        }
        if (searchString == "") {
            let sorted = favorites.keys.sort({ (firstKey, secondKey) -> Bool in
                return favorites[secondKey] < favorites[firstKey]
            })
            if self.cancelled {
                return
            }
            emojiSet.unionInPlace(Array(sorted.prefix(displayConstant)))
        }
        if self.cancelled {
            return
        }
        for (key, values) in nameData! {
            if self.cancelled {
                return
            }
            if (key.hasPrefix(searchString)) {
                emojiSet.unionInPlace(Array(values as! [String]))
            }
            if self.cancelled {
                return
            }
        }
        if self.cancelled {
            return
        }
        searchOutput = Array(emojiSet)
        if self.cancelled {
            return
        }
        searchOutput.sortInPlace({ (firstKey, secondKey) -> Bool in
            return favorites[secondKey] < favorites[firstKey]
        })
        if self.cancelled {
            return
        }
    }

}
