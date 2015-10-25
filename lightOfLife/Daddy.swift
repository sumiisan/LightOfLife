//
//  Fluor.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015 sumiisan. All rights reserved.
//

import SpriteKit

class Daddy : Mortals {
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
		let texture = SKTexture(imageNamed: "fluor")
		super.init(texture: texture, color: UIColor(hue: 0.6, saturation: 0.5, brightness: 1.0, alpha: 1.0), size: texture.size() * 0.8)
		zPosition = 40000
		colorBlendFactor = 1.0
		
		maxEnergy = 1000			//	TODO: charge energy when the first fluor is born
		energy = maxEnergy			//	TODO: charge energy when the first fluor is born

		/*
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("lightTapped:"), name: Notification.LightTapped.rawValue, object: nil)
		*/
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
	/*
	func lightTapped(notifiation:NSNotification) {
		planMoveToCell(IntPoint(
			x: notifiation.userInfo!["x"]!.integerValue,
			y: notifiation.userInfo!["y"]!.integerValue
			))
	}
	*/
	/*--------------------------------
	MARK:	- move fluor
	---------------------------------*/
	internal func planMoveToCell( p:IntPoint ) {
		destination = p
		moveToNextHex()
	}

	func moveToNextHex() {
		let dir = hexgrid.quantizeDirectionTo(destination!)
		if dir == HexDirectionAll {
			//	no moves planned
			return
		}
		
		var targetP = hexgrid.neighbour(dir)
		var targetCell = StageMap.mainMap.cellWithPositionRangeCheck(targetP)
		var doesStopFluor = (targetCell != nil) ? targetCell!.doesStopFluor() : true

		if doesStopFluor {
			targetP = hexgrid.neighbour(hexgrid.alternativeTo(dir))
			targetCell = StageMap.mainMap.cellWithPositionRangeCheck(targetP)
			//	try another direction
			doesStopFluor = (targetCell != nil) ? targetCell!.doesStopFluor() : true
			if doesStopFluor {	//	wait 0.5 sec and try again
				runAction(nil, withKey: "move", after: 0.25, completion: { () -> Void in
					self.moveToNextHex()
				})
				rotateTo(dir)
				return
			}
		}
		
		rotateTo(dir)
		
		let targetScreenPosition = Screen.cellPosition(targetP)
		let moveAction   = SKAction.moveTo(targetScreenPosition, duration: 0.25)
		
		runAction(moveAction, withKey: "move") { () -> Void in
			self.hexgrid.position = targetP
			self.checkObjectUnderMyFeets()
			self.performSelector(Selector("moveToNextHex"), withObject: nil, afterDelay: 0.5)	//	this is daddy's normal speed
		}
	
	}
	
	func rotateTo(dir:HexDirection) {
		var angleDiff = CGFloat(dir * 60 + 210) - zRotation.radiansToDegrees
		if  angleDiff < 0 {
			angleDiff += 360
		}
		if angleDiff > 180 {
			angleDiff -= 360
		}
		//			print("delta-th:\(angleDiff)")
		let rotateAction = SKAction.rotateToAngle(angleDiff.degreesToRadians + zRotation, duration: 0.3)
		runAction(rotateAction, withKey: "rotate")
	}

	func checkObjectUnderMyFeets() {
		let cell = StageMap.mainMap.cell(hexgrid.position)
		cell.atom.pass()
		
		let object = cell.object
		if let light = object as? Light {
			light.touch()
		}
	}
	
	override func update(currentTime: CFTimeInterval) {
		super.update(currentTime)
		beginFlood(StageMap.mainMap)
	}
	
	func beginFlood(stageMap: StageMap) {
		stageMap.alterAtom(mapPosition, multiplier: 1.01, offset: 0.1)
		
		let fp = FloodPointer(inPosition: mapPosition, inDirection: 6, inStrength: 1.0)
		let dirs = fp.directions()
		
		for d in dirs {
			let p = fp.neighbour(d)
			if stageMap.positionIsInsideMap(p) {
				if stageMap.cell(p).luminosity() < 0.5 {
					stageMap.alterAtom(p, multiplier: 1.111111, offset: 0.02)
				}
			}
		}
		
	}

}
