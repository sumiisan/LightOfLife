//
//  FloodPointer.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import Foundation
import CoreGraphics

typealias HexDirection = Int
let HexDirectionAll:HexDirection = 6

infix operator <+> { associativity left precedence 140 }
infix operator <-> { associativity left precedence 140 }
prefix operator <++> {}
prefix operator <--> {}

func <+> (left:HexDirection, right:Int) -> HexDirection {
	return ( left + right + 60000 ) % 6
}

func <-> (left:HexDirection, right:Int) -> HexDirection {
	return ( left - right + 60000 ) % 6
}
/*
prefix func <++> (inout direction:HexDirection) -> HexDirection {
	direction = (direction + HexDirection(5)) % 6
	return direction
}

prefix func <--> (inout direction:HexDirection) -> HexDirection {
	direction = (direction + HexDirection(1)) % 6
	return direction
}
*/

/*--------------------------------
MARK:	- Hexagonal grid
---------------------------------*/

class HexGrid {
	var position:IntPoint

	private static let baseDiff = [[0,-1],[1,0],[0,1],[-1,1],[-1,0],[-1,-1]]
	
	init(pos:IntPoint) {
		position = pos
	}
	
	init() {
		position = IntPoint(x: 0, y: 0)
	}
	
	func sixNeighbours() -> [IntPoint] {
		let x			= position.x
		let y			= position.y
		let xShift		= ( y % 2 == 0 ) ? 0 : 1
		//
		let upperRight	= IntPoint( x: x     + xShift,	y: y - 1 )
		let right		= IntPoint( x: x + 1,			y: y )
		let lowerRight	= IntPoint( x: x     + xShift,	y: y + 1 )
		let lowerLeft	= IntPoint( x: x - 1 + xShift,	y: y + 1 )
		let left		= IntPoint( x: x - 1,			y: y )
		let upperLeft	= IntPoint( x: x - 1 + xShift,	y: y - 1 )
		return [upperRight,right,lowerRight,lowerLeft,left,upperLeft]
	}
	
	func neighbour(inDirection:HexDirection) -> IntPoint {
		let d = HexGrid.baseDiff[inDirection]
		let xShift		= ( position.y % 2 == 0 || d[1] == 0 ) ? 0 : 1
		return IntPoint(x: position.x + d[0] + xShift, y: position.y + d[1])
	}
		
	func directions(baseDirection:HexDirection) -> [HexDirection] {
		if baseDirection == HexDirectionAll {
			return [0,1,2,3,4,5].shuffle()
		}
		
		if ( 2.randomNumber() == 0 ) {
			return [baseDirection,baseDirection<+>1,baseDirection<->1]
		} else {
			return [baseDirection,baseDirection<->1,baseDirection<+>1]
		}
	}
	
	final internal func alternativeTo( inDirection:HexDirection ) -> HexDirection {
		if ( 2.randomNumber() == 0 ) {
			return inDirection <+> 1
		} else {
			return inDirection <-> 1
		}
	}
	
	func quantizeDirectionTo( destination:IntPoint ) -> HexDirection {
		let dx = destination.x - position.x
		let dy = destination.y - position.y
		if( dx == 0 && dy == 0 ) {
			return HexDirectionAll
		}
		let rad:Double = atan2(Double(dy), Double(dx))
		let deg = rad.radiansToDegrees + 90
		let hd = HexDirection( ((deg + 360)%360) / CGFloat(60.0) )
		//print("dx:\(dx) dy:\(dy) deg:\(deg) hd:\(hd)")
		return hd
	}
	
}

/*--------------------------------
MARK:	- Flood pointer
---------------------------------*/

class FloodPointer : HexGrid {
	var strength:Double = 1.0
	var baseDirection:HexDirection = HexDirectionAll
	
	override init() {
		super.init()
	}
	
	internal convenience init(inPosition: IntPoint, inDirection: HexDirection, inStrength: Double) {
		self.init()
		position		= inPosition
		baseDirection	= inDirection
		strength		= inStrength
	}
	
	func directions() -> [HexDirection] {
		return directions(baseDirection)
	}
	
}