// MARK: - Mocks generated from file: cali/EventService.swift at 2018-08-13 23:41:00 +0000

//
//  EventsService.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Cuckoo
@testable import cali

import CoreData
import Foundation

class MockEventService: EventService, Cuckoo.ProtocolMock {
    typealias MocksType = EventService
    typealias Stubbing = __StubbingProxy_EventService
    typealias Verification = __VerificationProxy_EventService
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    

    

    
    // ["name": "find", "returnSignature": " -> [Event]", "fullyQualifiedName": "find(startDay: Date) -> [Event]", "parameterSignature": "startDay: Date", "parameterSignatureWithoutNames": "startDay: Date", "inputTypes": "Date", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "startDay", "call": "startDay: startDay", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("startDay"), name: "startDay", type: "Date", range: CountableRange(199..<213), nameRange: CountableRange(199..<207))], "returnType": "[Event]", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func find(startDay: Date)  -> [Event] {
        
            return cuckoo_manager.call("find(startDay: Date) -> [Event]",
                parameters: (startDay),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    
    // ["name": "createEvent", "returnSignature": " -> Event", "fullyQualifiedName": "createEvent(start: Date, duration: TimeInterval) -> Event", "parameterSignature": "start: Date, duration: TimeInterval", "parameterSignatureWithoutNames": "start: Date, duration: TimeInterval", "inputTypes": "Date, TimeInterval", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "start, duration", "call": "start: start, duration: duration", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("start"), name: "start", type: "Date", range: CountableRange(247..<258), nameRange: CountableRange(247..<252)), CuckooGeneratorFramework.MethodParameter(label: Optional("duration"), name: "duration", type: "TimeInterval", range: CountableRange(260..<282), nameRange: CountableRange(260..<268))], "returnType": "Event", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func createEvent(start: Date, duration: TimeInterval)  -> Event {
        
            return cuckoo_manager.call("createEvent(start: Date, duration: TimeInterval) -> Event",
                parameters: (start, duration),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    
    // ["name": "changeDay", "returnSignature": "", "fullyQualifiedName": "changeDay(event: Event, day: Date)", "parameterSignature": "event: Event, day: Date", "parameterSignatureWithoutNames": "event: Event, day: Date", "inputTypes": "Event, Date", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "event, day", "call": "event: event, day: day", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("event"), name: "event", type: "Event", range: CountableRange(312..<324), nameRange: CountableRange(312..<317)), CuckooGeneratorFramework.MethodParameter(label: Optional("day"), name: "day", type: "Date", range: CountableRange(326..<335), nameRange: CountableRange(326..<329))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func changeDay(event: Event, day: Date)  {
        
            return cuckoo_manager.call("changeDay(event: Event, day: Date)",
                parameters: (event, day),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    
    // ["name": "discardEvent", "returnSignature": "", "fullyQualifiedName": "discardEvent(_: Event)", "parameterSignature": "_ event: Event", "parameterSignatureWithoutNames": "event: Event", "inputTypes": "Event", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "event", "call": "event", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "event", type: "Event", range: CountableRange(359..<373), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func discardEvent(_ event: Event)  {
        
            return cuckoo_manager.call("discardEvent(_: Event)",
                parameters: (event),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_EventService: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func find<M1: Cuckoo.Matchable>(startDay: M1) -> Cuckoo.ProtocolStubFunction<(Date), [Event]> where M1.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: startDay) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventService.self, method: "find(startDay: Date) -> [Event]", parameterMatchers: matchers))
	    }
	    
	    func createEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(start: M1, duration: M2) -> Cuckoo.ProtocolStubFunction<(Date, TimeInterval), Event> where M1.MatchedType == Date, M2.MatchedType == TimeInterval {
	        let matchers: [Cuckoo.ParameterMatcher<(Date, TimeInterval)>] = [wrap(matchable: start) { $0.0 }, wrap(matchable: duration) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventService.self, method: "createEvent(start: Date, duration: TimeInterval) -> Event", parameterMatchers: matchers))
	    }
	    
	    func changeDay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, day: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Event, Date)> where M1.MatchedType == Event, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Event, Date)>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: day) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventService.self, method: "changeDay(event: Event, day: Date)", parameterMatchers: matchers))
	    }
	    
	    func discardEvent<M1: Cuckoo.Matchable>(_ event: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Event)> where M1.MatchedType == Event {
	        let matchers: [Cuckoo.ParameterMatcher<(Event)>] = [wrap(matchable: event) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventService.self, method: "discardEvent(_: Event)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_EventService: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func find<M1: Cuckoo.Matchable>(startDay: M1) -> Cuckoo.__DoNotUse<[Event]> where M1.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: startDay) { $0 }]
	        return cuckoo_manager.verify("find(startDay: Date) -> [Event]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func createEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(start: M1, duration: M2) -> Cuckoo.__DoNotUse<Event> where M1.MatchedType == Date, M2.MatchedType == TimeInterval {
	        let matchers: [Cuckoo.ParameterMatcher<(Date, TimeInterval)>] = [wrap(matchable: start) { $0.0 }, wrap(matchable: duration) { $0.1 }]
	        return cuckoo_manager.verify("createEvent(start: Date, duration: TimeInterval) -> Event", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func changeDay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, day: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Event, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Event, Date)>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: day) { $0.1 }]
	        return cuckoo_manager.verify("changeDay(event: Event, day: Date)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func discardEvent<M1: Cuckoo.Matchable>(_ event: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Event {
	        let matchers: [Cuckoo.ParameterMatcher<(Event)>] = [wrap(matchable: event) { $0 }]
	        return cuckoo_manager.verify("discardEvent(_: Event)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class EventServiceStub: EventService {
    

    

    
     func find(startDay: Date)  -> [Event] {
        return DefaultValueRegistry.defaultValue(for: [Event].self)
    }
    
     func createEvent(start: Date, duration: TimeInterval)  -> Event {
        return DefaultValueRegistry.defaultValue(for: Event.self)
    }
    
     func changeDay(event: Event, day: Date)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func discardEvent(_ event: Event)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: cali/LocationService.swift at 2018-08-13 23:41:00 +0000

//
//  LocationService.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Cuckoo
@testable import cali

import CoreLocation
import Foundation
import UIKit

class MockLocationServiceDelegate: LocationServiceDelegate, Cuckoo.ProtocolMock {
    typealias MocksType = LocationServiceDelegate
    typealias Stubbing = __StubbingProxy_LocationServiceDelegate
    typealias Verification = __VerificationProxy_LocationServiceDelegate
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    

    

    
    // ["name": "locationServiceDidUpdateLocation", "returnSignature": "", "fullyQualifiedName": "locationServiceDidUpdateLocation(_: LocationService)", "parameterSignature": "_ locationService: LocationService", "parameterSignatureWithoutNames": "locationService: LocationService", "inputTypes": "LocationService", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "locationService", "call": "locationService", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "locationService", type: "LocationService", range: CountableRange(258..<292), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func locationServiceDidUpdateLocation(_ locationService: LocationService)  {
        
            return cuckoo_manager.call("locationServiceDidUpdateLocation(_: LocationService)",
                parameters: (locationService),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_LocationServiceDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func locationServiceDidUpdateLocation<M1: Cuckoo.Matchable>(_ locationService: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(LocationService)> where M1.MatchedType == LocationService {
	        let matchers: [Cuckoo.ParameterMatcher<(LocationService)>] = [wrap(matchable: locationService) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLocationServiceDelegate.self, method: "locationServiceDidUpdateLocation(_: LocationService)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_LocationServiceDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func locationServiceDidUpdateLocation<M1: Cuckoo.Matchable>(_ locationService: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == LocationService {
	        let matchers: [Cuckoo.ParameterMatcher<(LocationService)>] = [wrap(matchable: locationService) { $0 }]
	        return cuckoo_manager.verify("locationServiceDidUpdateLocation(_: LocationService)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class LocationServiceDelegateStub: LocationServiceDelegate {
    

    

    
     func locationServiceDidUpdateLocation(_ locationService: LocationService)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


class MockLocationService: LocationService, Cuckoo.ProtocolMock {
    typealias MocksType = LocationService
    typealias Stubbing = __StubbingProxy_LocationService
    typealias Verification = __VerificationProxy_LocationService
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "location", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "CLLocation?", "isReadOnly": true, "accessibility": ""]
     var location: CLLocation? {
        get {
            
            return cuckoo_manager.getter("location", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    
    // ["name": "ensureLocation", "returnSignature": "", "fullyQualifiedName": "ensureLocation(from: UIViewController)", "parameterSignature": "from: UIViewController", "parameterSignatureWithoutNames": "from: UIViewController", "inputTypes": "UIViewController", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "from", "call": "from: from", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("from"), name: "from", type: "UIViewController", range: CountableRange(1054..<1076), nameRange: CountableRange(1054..<1058))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func ensureLocation(from: UIViewController)  {
        
            return cuckoo_manager.call("ensureLocation(from: UIViewController)",
                parameters: (from),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_LocationService: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var location: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockLocationService, CLLocation?> {
	        return .init(manager: cuckoo_manager, name: "location")
	    }
	    
	    
	    func ensureLocation<M1: Cuckoo.Matchable>(from: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(UIViewController)> where M1.MatchedType == UIViewController {
	        let matchers: [Cuckoo.ParameterMatcher<(UIViewController)>] = [wrap(matchable: from) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLocationService.self, method: "ensureLocation(from: UIViewController)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_LocationService: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var location: Cuckoo.VerifyReadOnlyProperty<CLLocation?> {
	        return .init(manager: cuckoo_manager, name: "location", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func ensureLocation<M1: Cuckoo.Matchable>(from: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UIViewController {
	        let matchers: [Cuckoo.ParameterMatcher<(UIViewController)>] = [wrap(matchable: from) { $0 }]
	        return cuckoo_manager.verify("ensureLocation(from: UIViewController)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class LocationServiceStub: LocationService {
    
     var location: CLLocation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CLLocation?).self)
        }
        
    }
    

    

    
     func ensureLocation(from: UIViewController)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: cali/Storage.swift at 2018-08-13 23:41:00 +0000

//
//  Storage.swift
//  cali
//
//  Created by will3 on 8/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Cuckoo
@testable import cali

import CoreData
import Foundation

class MockStorage: Storage, Cuckoo.ProtocolMock {
    typealias MocksType = Storage
    typealias Stubbing = __StubbingProxy_Storage
    typealias Verification = __VerificationProxy_Storage
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "context", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "NSManagedObjectContext", "isReadOnly": true, "accessibility": ""]
     var context: NSManagedObjectContext {
        get {
            
            return cuckoo_manager.getter("context", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    
    // ["name": "saveContext", "returnSignature": "", "fullyQualifiedName": "saveContext()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func saveContext()  {
        
            return cuckoo_manager.call("saveContext()",
                parameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    
    // ["name": "clear", "returnSignature": "", "fullyQualifiedName": "clear()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func clear()  {
        
            return cuckoo_manager.call("clear()",
                parameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_Storage: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var context: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockStorage, NSManagedObjectContext> {
	        return .init(manager: cuckoo_manager, name: "context")
	    }
	    
	    
	    func saveContext() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockStorage.self, method: "saveContext()", parameterMatchers: matchers))
	    }
	    
	    func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockStorage.self, method: "clear()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Storage: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var context: Cuckoo.VerifyReadOnlyProperty<NSManagedObjectContext> {
	        return .init(manager: cuckoo_manager, name: "context", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func saveContext() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("saveContext()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func clear() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("clear()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class StorageStub: Storage {
    
     var context: NSManagedObjectContext {
        get {
            return DefaultValueRegistry.defaultValue(for: (NSManagedObjectContext).self)
        }
        
    }
    

    

    
     func saveContext()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func clear()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: cali/WeatherService.swift at 2018-08-13 23:41:00 +0000

//
//  WeatherService.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Cuckoo
@testable import cali

import CoreLocation
import Foundation
import UIKit

class MockWeatherService: WeatherService, Cuckoo.ProtocolMock {
    typealias MocksType = WeatherService
    typealias Stubbing = __StubbingProxy_WeatherService
    typealias Verification = __VerificationProxy_WeatherService
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    

    

    
    // ["name": "getWeather", "returnSignature": "", "fullyQualifiedName": "getWeather(location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void)", "parameterSignature": "location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void", "parameterSignatureWithoutNames": "location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void", "inputTypes": "CLLocation, (CurlError?, weatherForecastResponse?) -> Void", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": true, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "location, block", "call": "location: location, block: block", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("location"), name: "location", type: "CLLocation", range: CountableRange(366..<386), nameRange: CountableRange(366..<374)), CuckooGeneratorFramework.MethodParameter(label: Optional("block"), name: "block", type: "@escaping(CurlError?, weatherForecastResponse?) -> Void", range: CountableRange(388..<450), nameRange: CountableRange(388..<393))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func getWeather(location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void)  {
        
            return cuckoo_manager.call("getWeather(location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void)",
                parameters: (location, block),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_WeatherService: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getWeather<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(location: M1, block: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(CLLocation, (CurlError?, weatherForecastResponse?) -> Void)> where M1.MatchedType == CLLocation, M2.MatchedType == (CurlError?, weatherForecastResponse?) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CLLocation, (CurlError?, weatherForecastResponse?) -> Void)>] = [wrap(matchable: location) { $0.0 }, wrap(matchable: block) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWeatherService.self, method: "getWeather(location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_WeatherService: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getWeather<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(location: M1, block: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == CLLocation, M2.MatchedType == (CurlError?, weatherForecastResponse?) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CLLocation, (CurlError?, weatherForecastResponse?) -> Void)>] = [wrap(matchable: location) { $0.0 }, wrap(matchable: block) { $0.1 }]
	        return cuckoo_manager.verify("getWeather(location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class WeatherServiceStub: WeatherService {
    

    

    
     func getWeather(location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

