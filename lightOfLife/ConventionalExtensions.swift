//
//  ConventionalExtensions.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

/*--------------------------------
MARK:	- color with hexadecimal RGB value
---------------------------------*/
extension UIColor {
	static func colorWithHex( hex:UInt32 ) -> UIColor {
		var a = hex
		
		let b:CGFloat = CGFloat(a & 0xff) / 255.0
		a >>= 8
		let g:CGFloat = CGFloat(a & 0xff) / 255.0
		a >>= 8
		let r:CGFloat = CGFloat(a & 0xff) / 255.0
		
		return UIColor(
			red: r,
			green: g,
			blue: b,
			alpha: 1.0 )
	}
}


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
MARK:	- actions
---------------------------------*/
extension SKNode {
	public func runAction(action: SKAction, withKey key: String, completion block: () -> Void) {
		let seq = SKAction.sequence([action,SKAction.runBlock(block)])
		runAction(seq, withKey: key)
	}
	
	public func runAction(action: SKAction?, withKey key: String, after sec:NSTimeInterval, completion block: () -> Void) {
		let wait = SKAction.waitForDuration(sec)
		var seq:SKAction;
		let blockAction = SKAction.runBlock(block)
		if( action != nil ) {
			seq = SKAction.sequence([wait,action!,blockAction])
		} else {
			seq = SKAction.sequence([wait,blockAction])
		}
		runAction(seq, withKey: key)
	}
}

/*--------------------------------
MARK:	- multiply CGSize
---------------------------------*/

func * (left: CGSize, right: CGFloat) -> CGSize {
	return CGSizeMake(left.width * right, left.height * right )
}



