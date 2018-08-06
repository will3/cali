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
    case vertical
    case horizontal
}

enum LayoutSize {
    case none
    case value(Float)
    case ratio(Float)
}

enum LayoutFit {
    case none
    case leading
    case center
    case trailing
    case stretch
}

enum LayoutPriority {
    case none
    case more(Float)
    case less(Float)
    case value(Float)
}
