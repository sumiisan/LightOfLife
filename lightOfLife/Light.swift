//
//  Light.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

enum LightStates {
	case Off
	case On
}

typealias ScanDirection = Int

class FloodPointer {
	var position = IntPoint(x: 0, y: 0)
	var strength:Double = 1.0
	var baseDirection:ScanDirection = 6
	
	internal convenience init(inPosition: IntPoint, inDirection: ScanDirection, inStrength: Double) {
		self.init()
		position		= inPosition
		baseDirection	= inDirection
		strength		= inStrength
	}
	
	/**

			   (0,3)	(1,3)	(2,3)	(3,3)	(4,3)
	
			(0,2)	(1,2)	(2,2)	(3,2)	(4,2)
	
			   (0,1)	(1,1)	(2,1)	(3,1)	(4,1)
	
			(0,0)	(1,0)	(2,0)	(3,0)	(4,0)


	*/
	private let baseDiff = [[0,-1],[1,0],[0,1],[-1,1],[-1,0],[-1,-1]]

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
	
	func neighbour(inDirection:ScanDirection) -> IntPoint {
		let d = baseDiff[inDirection]
		let xShift		= ( position.y % 2 == 0 || d[1] == 0 ) ? 0 : 1
		return IntPoint(x: position.x + d[0] + xShift, y: position.y + d[1])
	}
	
	func directionWithOffset( inDirection:ScanDirection, offset:Int ) -> ScanDirection {
		return ( inDirection + offset + 60000 ) % 6	//	60000 is a relative big number (without sense) we can divide by 6.
	}
	

	func directions() -> [ScanDirection] {
		if baseDirection == 6 {
			return [0,1,2,3,4,5]
		}
		return [baseDirection,(baseDirection+1)%6,(baseDirection+5)%6]	//	+5 equals -1
	}
	
	
	
}

class Light : SKShapeNode {
	var mapPosition = IntPoint(x:0, y:0)
	var state_ = LightStates.Off
	var state:LightStates {
		get {
			return state_
		}
		set(s) {
			state_ = s
			hidden = s == LightStates.Off
		}
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setBasics()
	}
	
	override init() {
		super.init()
		setBasics()
	}

	func setBasics() {
		state = LightStates.Off
		zPosition = 10000
		fillColor = UIColor.whiteColor()
	}
	
	func beginFlood( stageMap:StageMap ) {
		if state == .On {
			let fp = FloodPointer(inPosition: mapPosition, inDirection:6, inStrength: 1.0 )
			flood( stageMap, floodPointerList: [fp] )
		}
	}
	
	func flood( stageMap:StageMap, floodPointerList:[FloodPointer] ) {
		var nextFloodPointerList = [FloodPointer]()
		for fp in floodPointerList {
			let directions = fp.directions()
			for direction in directions {
				let pos = fp.neighbour(direction)
				let strength = fp.strength
//				let dirFactor = strength * (direction == fp.baseDirection ? 0.5 : 0.5 )
				if stageMap.alterAtomWithPositionRangeCheck(
					pos,
					multiplier: 1.03,// + (0.3 * strength * dirFactor),
					offset:     0.02 * strength// * dirFactor
					) {
						let nextStrength = strength * 0.4 + stageMap.lastFramesLuminosity[pos.y][pos.x] * 0.3
						if( nextStrength > 0.2 ) {
							if( stageMap.floodScannedWithStrength[pos.y][pos.x] == 0 ) {
								let newFp = FloodPointer(inPosition: pos, inDirection: direction, inStrength: nextStrength )
								nextFloodPointerList.append(newFp)
								stageMap.floodScannedWithStrength[pos.y][pos.x] = nextStrength
							}
						}
				}
			}
		}
		if nextFloodPointerList.count > 0 {
			flood(stageMap,floodPointerList: nextFloodPointerList )
		}
	}
	
	
	
	
	
}
