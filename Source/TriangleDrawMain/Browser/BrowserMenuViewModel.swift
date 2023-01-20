// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import Foundation
import Combine
import SwiftUI

public class BrowserMenuViewModel: ObservableObject {
    @Published var appVersion: String = "x.y.z"
    @Published var appCreationDateString: String = "yyyy-mm-dd"
    @Published var appRunCount: String = "x"

    static func create() -> BrowserMenuViewModel {
        let runCount: Int = UserDefaults.standard.td_runCount()
        let instance = BrowserMenuViewModel()
        instance.appVersion = SystemInfo.appVersion
        instance.appCreationDateString = SystemInfo.creationDateStringShort
        instance.appRunCount = "\(runCount)"
        return instance
    }
}
