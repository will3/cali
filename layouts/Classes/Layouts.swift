//
//  Layouts.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

#if !NO_LAYOUT_SHORTHANDS
    public func layout(_ view: UIView) -> LayoutBuilder {
        return Layouts.view(view)
    }
#endif

public class Layouts {
    public static func view(_ view: UIView) -> LayoutBuilder {
        return LayoutBuilder(view: view)
    }
}

/// Layout direction
public enum LayoutDirection {
    case vertical
    case horizontal
}

/// Layout size
public enum LayoutSize {
    case none
    case value(Float)
    case ratio(Float)
}

/// Layout fit
public enum LayoutFit {
    case none
    case leading
    case center
    case trailing
    case stretch
}

/// Layout priority
public enum LayoutPriority {
    case none
    case more(Float)
    case less(Float)
    case value(Float)
}

/// Layout justify
public enum LayoutJustify {
    case stretch
    case leading
}
