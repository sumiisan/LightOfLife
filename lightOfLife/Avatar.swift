//
//  Avatar.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Avatar : SKSpriteNode {
	private var hexgrid:HexGrid = HexGrid()
	private var destination_:IntPoint? = nil
	internal var destinationMark:SKSpriteNode = SKSpriteNode(imageNamed: "mark")
	
	var mapPosition:IntPoint {
		get {
			return hexgrid.position
		}
		set(p) {
			hexgrid.position = p
			position = Screen.cellPosition(p)
		}
	}
	
	var destination:IntPoint? {
		get {
			return destination_
		}
		set(p) {
			destination_ = p
			destinationMark.position = Screen.cellPosition(p!)
			destinationMark.zPosition = 39000
			destinationMark.setScale(0.5)
			destinationMark.hidden = false
		}
	}
	
	override init(texture: SKTexture?, color: UIColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	init() {
		let texture = SKTexture(imageNamed: "arrow")
		super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * 0.8)
		zPosition = 40000
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("lightTapped:"), name: Notification.LightTapped.rawValue, object: nil)
		
		destinationMark.hidden = true
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	/*--------------------------------
	MARK:	- interaction (message received)
	---------------------------------*/
	func lightTapped(notifiation:NSNotification) {
		planMoveToMapPosition(IntPoint(
			x: notifiation.userInfo!["x"]!.integerValue,
			y: notifiation.userInfo!["y"]!.integerValue
			))
	}
	
	/*--------------------------------
	MARK:	- move avatar
	---------------------------------*/
	internal func planMoveToMapPosition( p:IntPoint ) {
		destination = p
		moveToNextHex()
	}

	func moveToNextHex() {
		let dir = hexgrid.quantizeDirectionTo(destination!)
		if dir != HexDirectionAll {
			let destMapP    = hexgrid.neighbour(dir)
			let destScreenP = Screen.cellPosition(destMapP)
			let moveAction   = SKAction.moveTo(destScreenP, duration: 1.0)
			var angleDiff = CGFloat(dir * 60 + 210) - zRotation.radiansToDegrees
			if  angleDiff < 0 {
				angleDiff += 360
			}
			if angleDiff > 180 {
				angleDiff -= 360
			}
//			print("delta-th:\(angleDiff)")
			let rotateAction = SKAction.rotateToAngle(angleDiff.degreesToRadians + zRotation, duration: 0.5)
			
			runAction(moveAction, withKey: "move") { () -> Void in
				self.hexgrid.position = destMapP
				self.moveToNextHex()
				
				self.checkObjectUnderMyFeets()
			}
			runAction(rotateAction, withKey: "rotate")
		}
	}

	func checkObjectUnderMyFeets() {
		let object = StageMap.mainMap.objectAt(hexgrid.position)
		if let light = object as? Light {
			light.touch()
		}
	}
	
	
	func beginFlood(stageMap: StageMap) {
		stageMap.alterAtom(mapPosition, multiplier: 1.01, offset: 0.1)
		
		let fp = FloodPointer(inPosition: mapPosition, inDirection: 6, inStrength: 1.0)
		let dirs = fp.directions()
		
		for d in dirs {
			let p = fp.neighbour(d)
			stageMap.alterAtom(p, multiplier: 1.01, offset: 0.01)
		}
		
	}

}
