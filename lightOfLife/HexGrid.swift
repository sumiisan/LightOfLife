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

/*--------------------------------
MARK:	- Hexagonal grid
---------------------------------*/

class HexGrid {
	var position = IntPoint(x: 0, y: 0)

	private static let baseDiff = [[0,-1],[1,0],[0,1],[-1,1],[-1,0],[-1,-1]]
	
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
	
	func directionWithOffset( inDirection:HexDirection, offset:Int ) -> HexDirection {
		return ( inDirection + offset + 60000 ) % 6	//	60000 is a relative big number (without sense) we can divide by 6.
	}
	
	func directions(baseDirection:HexDirection) -> [HexDirection] {
		if baseDirection == HexDirectionAll {
			return [0,1,2,3,4,5].shuffle()
		}
		
		if ( 2.randomNumber() == 0 ) {
			return [baseDirection,(baseDirection+1)%6,(baseDirection+5)%6]	//	+5 equals -1
		} else {
			return [baseDirection,(baseDirection+5)%6,(baseDirection+1)%6]	//	+5 equals -1
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