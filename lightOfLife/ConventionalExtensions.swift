//
//  ConventionalExtensions.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

/*--------------------------------
MARK:	- shuffle arrays
---------------------------------*/
extension CollectionType where Index == Int {
	/// Return a copy of `self` with its elements shuffled
	func shuffle() -> [Generator.Element] {
		var list = Array(self)
		list.shuffleInPlace()
		return list
	}
}

extension MutableCollectionType where Index == Int {
	/// Shuffle the elements of `self` in-place.
	mutating func shuffleInPlace() {
		// empty and single-element collections don't shuffle
		if count < 2 { return }
		
		for i in 0..<count - 1 {
			let j = (count - i).randomNumber() + i
			guard i != j else { continue }
			swap(&self[i], &self[j])
		}
	}
}

/*--------------------------------
MARK:	- angle conversions, random numbers
---------------------------------*/
extension Int {
	var degreesToRadians : CGFloat {
		return CGFloat(self) * CGFloat(M_PI) / 180.0
	}
	
	var radiansToDegrees : CGFloat {
		return CGFloat(self) * CGFloat(180.0 / M_PI)
	}
	
	func randomNumber() -> Int {
		return Int( arc4random_uniform( UInt32(self)) )
	}
}

extension Double {
	var degreesToRadians : CGFloat {
		return CGFloat(self) * CGFloat(M_PI) / 180.0
	}
	
	var radiansToDegrees : CGFloat {
		return CGFloat(self) * CGFloat(180.0 / M_PI)
	}
}

extension CGFloat {
	var degreesToRadians : CGFloat {
		return CGFloat(self) * CGFloat(M_PI) / 180.0
	}
	
	var radiansToDegrees : CGFloat {
		return CGFloat(self) * CGFloat(180.0 / M_PI)
	}
}

/*--------------------------------
MARK:	- action with key and competion block
---------------------------------*/
extension SKNode {
	public func runAction(action: SKAction, withKey key: String, completion block: () -> Void) {
		let seq = SKAction.sequence([action,SKAction.runBlock(block)])
		runAction(seq, withKey: key)
	}
}

/*--------------------------------
MARK:	- multiply CGSize
---------------------------------*/

func * (left: CGSize, right: CGFloat) -> CGSize {
	return CGSizeMake(left.width * right, left.height * right )
}



