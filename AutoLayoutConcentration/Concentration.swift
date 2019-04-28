//
//  Concentration.swift
//  Concentration
//
//  Created by MB on 3/25/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation


struct Concentration
{
    private(set) var cards = [Card]()

    //Computed Property with get and set
    private var indexOfOneAndOnlyFaceUpCard : Int?{
        get{
            
           // let ch = "hello".oneAndOnly // return nil has it has more than 1 elements
            
            return cards.indices.filter({cards[$0].isFaceUp }).oneAndOnly
            
//            let faceUpCardsIndices = cards.indices.filter({cards[$0].isFaceUp }).oneAndOnly
            
//            return faceUpCardsIndices.count == 1 ? faceUpCardsIndices.first : nil
            
//            var foundIndex : Int?
//            for index in cards.indices{
//                //checking  if any cards is faceUp and for 2 or 0 cards face up it returns nil else it returns index
//                if cards[index].isFaceUp {
//                    if foundIndex == nil{
//                        foundIndex = index
//                    }
//                    else{
//                        foundIndex = nil
//                    }
//                }
//            }
//            return foundIndex
        }

          set{

            for index in cards.indices{
                cards[index].isFaceUp = (index==newValue)
            }
        }
    }
    
     mutating func chooseCard(at index : Int){
        //MARK:- Assert
        assert(cards.indices.contains(index),"Concentration.chooseCard(at \(index)): choosen index not in the cards")
        
        //checking if cards aint matched
        if !cards[index].isMatched{
            
            //checking if indexOfOneAndOnlyFaceUpCard have value and if current index is not equals to it
            if let matchIndex = indexOfOneAndOnlyFaceUpCard,matchIndex != index{
                //check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                // turning second card up irrespective of if itsd matched or not
                cards[index].isFaceUp = true

            }
            else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    

    init(numberOfPairsOfCards : Int){
        
        assert(numberOfPairsOfCards>0,"Concentration.init(\(numberOfPairsOfCards)) : you must have atleast one pair of cards")
        
        for _ in 1...numberOfPairsOfCards{
            
            let card = Card()
            cards += [card,card]
        }

        for cardIndex in cards.indices{
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            (cards[cardIndex],cards[randomIndex]) = (cards[randomIndex],cards[cardIndex])
        }
        
    }
}

extension Collection{
    // Element is generic type of Collection
    var oneAndOnly : Element?{
        //since count and first collection method we can use them
        return count == 1 ? first : nil
    }
}
