//
//  NowProvider.swift
//  cali
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

protocol NowProvider {
    var now: Date { get }
}

class NowProviderImpl : NowProvider {
    var now: Date { return Date() }
}
