//
//  Faker.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class Faker {
    var random = Random(seed: 1337)
    
    var firstName: String {
        return randomItem(array: FakerPool.firstNames)
    }
    
    var lastName: String {
        return randomItem(array: FakerPool.lastNames)
    }
    
    var startTime: TimeInterval {
        return randomItem(array: FakerPool.halfHours)
    }
    
    var duration: TimeInterval {
        return randomItem(array: FakerPool.durations)
    }
    
    private func randomItem<T>(array: [T]) -> T {
        let index = Int(floor(random.next() * Float(array.count)))
        return array[index]
    }
    
    func event(day: Date) -> Event {
        var event = Event()
        event.start = day.addingTimeInterval(startTime)
        event.duration = duration
        
        return event
    }
//    var event: Event {
//        var event = Event()
//        event.start =
//    }
}

class FakerPool {
    static var halfHours: [TimeInterval] = [
        60 * 60 * 8,
        60 * 60 * 8.5,
        60 * 60 * 9,
        60 * 60 * 9.5,
        60 * 60 * 10,
        60 * 60 * 10.5,
        60 * 60 * 11,
        60 * 60 * 11.5,
        60 * 60 * 12,
        60 * 60 * 12.5,
        60 * 60 * 13,
        60 * 60 * 13.5,
        60 * 60 * 14,
        60 * 60 * 14.5,
        60 * 60 * 15,
        60 * 60 * 15.5,
        60 * 60 * 16,
        60 * 60 * 16.5,
        60 * 60 * 17,
        60 * 60 * 17.5,
        60 * 60 * 18,
        60 * 60 * 18.5
    ]
    
    static var durations: [TimeInterval] = [
        60 * 60,
        60 * 60 * 0.5,
        60 * 60 * 0.75,
        60 * 60 * 1.5
    ]
    
    // https://www.babycenter.com/top-baby-names-2018.htm
    static var firstNames = [ "Emma", "Liam", "Olivia", "Noah", "Ava", "Oliver", "Isabella", "Mason", "Sophia", "Lucas", "Amelia", "Logan", "Mia", "Elijah", "Charlotte", "Ethan", "Harper", "James", "Mila", "Aiden", "Aria", "Carter", "Ella", "Jackson", "Evelyn", "Alexander", "Avery", "Sebastian", "Abigail", "Benjamin", "Luna", "Michael", "Emily", "Jacob", "Scarlett", "William", "Riley", "Grayson", "Chloe", "Jack", "Sofia", "Daniel", "Layla", "Henry", "Lily", "Owen", "Ellie", "Luke", "Madison", "Leo", "Zoey", "Wyatt", "Elizabeth", "Jayden", "Penelope", "Julian", "Victoria", "Gabriel", "Grace", "David", "Nora", "Matthew", "Camila", "Jaxon", "Bella", "Levi", "Aubrey", "Mateo", "Hannah", "Muhammad", "Aurora", "Lincoln", "Addison", "Asher", "Stella", "Samuel", "Savannah", "John", "Skylar", "Ryan", "Paisley", "Adam", "Maya", "Isaac", "Emilia", "Nathan", "Natalie", "Josiah", "Elena", "Joseph", "Hazel", "Isaiah", "Violet", "Caleb", "Nova", "Anthony", "Niamey", "Hunter", "Eva", "Eli" ]
    
    // https://names.mongabay.com/data/1000.html
    static var lastNames = [ "Smith", "Johnson", "Williams", "Brown", "Jones", "Miller", "Davis", "Garcia", "Rodriguez", "Wilson", "Martinez", "Anderson", "Taylor", "Thomas", "Hernandez", "Moore", "Martin", "Jackson", "Thompson", "White", "Lopez", "Lee", "Gonzalez", "Harris", "Clark", "Lewis", "Robinson", "Walker", "Perez", "Hall", "Young", "Allen", "Sanchez", "Wright", "King", "Scott", "Green", "Baker", "Adams", "Nelson", "Hill", "Ramirez", "Campbell", "Mitchell", "Roberts", "Carter", "Phillips", "Evans", "Turner", "Torres", "Parker", "Collins", "Edwards", "Stewart", "Flores", "Morris", "Nguyen", "Murphy", "Rivera", "Cook", "Rogers", "Morgan", "Peterson", "Cooper", "Reed", "Bailey", "Bell", "Gomez", "Kelly", "Howard", "Ward", "Cox", "Diaz", "Richardson", "Wood", "Watson", "Brooks", "Bennett", "Gray", "James", "Reyes", "Cruz", "Hughes", "Price", "Myers", "Long", "Foster", "Sanders", "Ross", "Morales", "Powell", "Sullivan", "Russell", "Ortiz", "Jenkins", "Gutierrez", "Perry", "Butler", "Barnes", "Fisher" ]
    
    static var eventNames = [
        "Personal projects",
        "Gym",
        "Interview",
        "Meeting",
        "Coffee",
        "Tidy room",
        "Meet-up",
        "Groceries",
        "Pitch ideas",
        "Read TechCrunch",
        "Audiobook",
    ]
    
    static var places = [
        "Home",
        "Office",
        "Library",
        "In my room",
        "In my basement",
        "Place called outside"
    ]
}
