// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

// Keep track of how many times the app have been started
extension UserDefaults {
    func td_incrementRunCount() {
        let runCount: Int = td_runCount()
        set(runCount + 1, forKey: TRIANGLEDRAW_RUN_COUNT)
        synchronize()
    }

    // Returns 0 the very first time the app is being started
    // This number is incremented on following starts
    func td_runCount() -> Int {
        return integer(forKey: TRIANGLEDRAW_RUN_COUNT)
    }
}

let TRIANGLEDRAW_RUN_COUNT = "TRIANGLEDRAW_RUN_COUNT"
