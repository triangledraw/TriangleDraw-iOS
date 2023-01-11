// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import Foundation
import Combine
import SwiftUI

public class HCMenuViewModel: ObservableObject {
    static func create() -> HCMenuViewModel {
        let instance = HCMenuViewModel()
        return instance
    }
}
