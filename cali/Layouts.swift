//
//  Layouts.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

#if !NO_LAYOUT_SHORTHANDS
    func layout(_ view: UIView) -> LayoutBuilder {
        return Layouts.view(view)
    }
#endif

class Layouts {
    static func view(_ view: UIView) -> LayoutBuilder {
        return LayoutBuilder(view: view)
    }
}

enum LayoutDirection {
    case Vertical
    case Horizontal
}

enum LayoutSize {
    case Default
    case Value(Float)
    case Ratio(Float)
}

enum LayoutFit {
    case Default
    case Leading
    case Center
    case Trailing
    case Stretch
}
