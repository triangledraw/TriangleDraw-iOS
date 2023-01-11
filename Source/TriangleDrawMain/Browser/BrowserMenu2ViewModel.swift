// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import Foundation
import Combine
import SwiftUI

public class BrowserMenu2ViewModel: ObservableObject {
    @Published var appVersion: String = "x.y.z"
    @Published var appCreationDateString: String = "yyyy-mm-dd"
    @Published var appRunCount: String = "x"

    static func create() -> BrowserMenu2ViewModel {
        let runCount: Int = UserDefaults.standard.td_runCount()
        let instance = BrowserMenu2ViewModel()
        instance.appVersion = SystemInfo.appVersion
        instance.appCreationDateString = SystemInfo.creationDateStringShort
        instance.appRunCount = "\(runCount)"
        return instance
    }
}
