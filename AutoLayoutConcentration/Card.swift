//
//  Card.swift
//  Concentration
//
//  Created by MB on 3/25/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation

//struct no inheriance , they are value types (they get copied (copy on write semantics used)(Array,String,Dictionary,Int, almost all are structs so you cant avoid struct in Swift))

//struct also gets a free init but it initializes each and every instance variables

//making card hashable
struct Card : Hashable{
    
    // HashValue for Hashable
    var hashValue: Int { return identifier }
    
    //Equatable to actually check if 2 values are equal or not
    static func == (lhs: Card, rhs: Card) -> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    // due to Card being Hashable now we can now make identifier private now which make code much cleaner
    private var identifier : Int
    
    
    private static var identifierFactory = 0
    
    //Static Methods are sent to Type
    private static func getUniqueIdentifier() -> Int {
       // dont need to type Card as we are in Type Card
        //Card.identifierFactory+=1
        identifierFactory+=1
        return identifierFactory
    }
            
    //init tends to have same external and internal names
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
