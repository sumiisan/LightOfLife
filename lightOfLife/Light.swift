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

class Light : MapObject {
	/*--------------------------------
	MARK:	- private vars
	---------------------------------*/

	private var state_ = LightStates.Off
	private var covered_ = true
	
	/*--------------------------------
	MARK:	- getter / setter
	---------------------------------*/

	var state:LightStates {
		get {
			return state_
		}
		set(s) {
			state_ = s
			if s == LightStates.On {
				color = UIColor.whiteColor()
				runAction(SKAction.rotateByAngle(0.01, duration: NSTimeInterval.infinity), withKey: "rotate")
			} else {
				color = UIColor(white: 0.2, alpha: 1.0)
				removeActionForKey("rotate")
			}
		}
	}
	
	var covered:Bool {
		get {
			return covered_
		}
		set(c) {
			covered_ = c
			hidden = c
			userInteractionEnabled = !c
		}
	}
	
	/*--------------------------------
	MARK:	- init
	---------------------------------*/

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setBasics()
	}
	
	init() {
		let texture = SKTexture(imageNamed: "light")
		super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * 0.5)
		setBasics()
	}

	private func setBasics() {
		colorBlendFactor = 1
		state = LightStates.Off
		covered = true
		zPosition = 10000
	}
	
	/*--------------------------------
	MARK:	- state change
	---------------------------------*/
	func uncover() {
		covered = false
	}
	
	/*--------------------------------
	MARK:	- interaction
	---------------------------------*/

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		//let touch = touches.first
		//state = state == LightStates.Off ? LightStates.On : LightStates.Off
		NSNotificationCenter.defaultCenter().postNotificationName(
			Notification.LightTapped.rawValue,
			object: self,
			userInfo: ["x":mapPosition.x, "y":mapPosition.y]
		)
	}

	/*--------------------------------
	MARK:	- flood
	---------------------------------*/
	
	override func beginFlood( stageMap:StageMap ) {
		if state == .On {
			let fp = FloodPointer(inPosition: mapPosition, inDirection:6, inStrength: 1.0 )
			flood( stageMap, floodPointerList: [fp] )
		}
	}
	
	private func flood( stageMap:StageMap, floodPointerList:[FloodPointer] ) {
		var nextFloodPointerList = [FloodPointer]()
		for fp in floodPointerList {
			let directions = fp.directions()
			for direction in directions {
				let pos = fp.neighbour(direction)
				let strength = fp.strength
				let dirFactor = strength * (direction == fp.baseDirection ? 1.5 : 0.7 )
				if stageMap.alterAtomWithPositionRangeCheck(
					pos,
					multiplier: 1.00 + (0.03 * dirFactor),
					offset:     0.02 * strength// * dirFactor
					) {
						let lfl = stageMap.lastFramesLuminosity[pos.y][pos.x] * 0.5
						let nextStrength = strength * 0.4 + ( lfl < 1.0 ? lfl : 1.0 )
						if( nextStrength > 0.2 ) {
							if( stageMap.floodPossible[pos.y][pos.x] ) {
								let newFp = FloodPointer(inPosition: pos, inDirection: direction, inStrength: nextStrength )
								nextFloodPointerList.append(newFp)
								stageMap.floodPossible[pos.y][pos.x] = false
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
