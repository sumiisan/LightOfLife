//
//  Light.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

enum LightState {
	case Off
	case On
}

enum LightSize {
	case Big
	case Small
}

class Light : MapObject {
	/*--------------------------------
	MARK:	- private vars
	---------------------------------*/

	private var state_ = LightState.Off
	private var lightSize = LightSize.Small
	private var power_:Double = 0.0
	private var covered_ = true
	
	internal var capacity:Double = 2.0	//	small light class
	
	/*--------------------------------
	MARK:	- getter / setter
	---------------------------------*/

	var state:LightState {
		get {
			return state_
		}
		set(s) {
			state_ = s
			if s == LightState.On {
				color = UIColor.whiteColor()
				runAction(
					SKAction.repeatActionForever(
						SKAction.rotateByAngle( lightSize == LightSize.Small ? -3 : -1.5, duration: 1.0)
					), withKey: "rotate"
				)
			} else {
				color = UIColor(white: 0.1, alpha: 1.0)
				removeActionForKey("rotate")
			}
		}
	}
	
	var power:Double {
		get {
			return power_
		}
		set(p) {
			power_ = p
			let l = power > 1.0 ? 1.0 : power
			color = UIColor(white: CGFloat(l), alpha: 1.0)
			if( power_ < 0.1 ) {
				state = LightState.Off
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
		super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * 0.45)
		setBasics()
	}

	private func setBasics() {
		type = .Light
		colorBlendFactor = 1
		state = LightState.Off
		covered = true
		zPosition = 10000
		if 4.randomNumber() == 0 {
			lightSize = LightSize.Big
			capacity = 4.0
		}
	}
	
	/*--------------------------------
	MARK:	- state change
	---------------------------------*/
	func uncover() {
		covered = false
	}
	
	func touch() {
		state = LightState.On
		power = capacity
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
	MARK:	- action
	---------------------------------*/
	override func update( stageMap:StageMap ) {
		if state == .On {
			power -= 0.001
			let fp = FloodPointer(inPosition: mapPosition, inDirection:6, inStrength: (power > 1 ? 1.0 : power ) )
			stageMap.cells[mapPosition.y][mapPosition.x].atom.luminosity = 1.0
			flood( stageMap, floodPointerList: [fp] )
		} else if covered {
			if stageMap.cells[mapPosition.y][mapPosition.x].luminosity() > 0.3 {
				covered = false
			}
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
						let lfl = stageMap.cells[pos.y][pos.x].lastFrameLuminosity * 0.5
						let nextStrength = strength * 0.4 + ( lfl < 1.0 ? lfl : 1.0 )
						if( nextStrength > 0.2 ) {
							if( stageMap.cells[pos.y][pos.x].floodable ) {
								let newFp = FloodPointer(inPosition: pos, inDirection: direction, inStrength: nextStrength )
								nextFloodPointerList.append(newFp)
								stageMap.cells[pos.y][pos.x].floodable = false
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
