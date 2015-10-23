//
//  Vine.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/07.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Vine : MapObject {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setBasics()
	}
	
	init() {
		let texture = SKTexture(imageNamed: "tree")
		super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * 0.9)
		setBasics()
	}
	
	private func setBasics() {
		type = .Vine
		colorBlendFactor = 1
		zPosition = 20000
	}
	
	override func update(stageMap: StageMap) {
		let fp = FloodPointer(inPosition: mapPosition, inDirection: 6, inStrength: 1.0)
		let dirs = fp.directions()
		for d in dirs {
			stageMap.alterAtomWithPositionRangeCheck(fp.neighbour(d), multiplier: 1.1, offset: 0)	//	slower decay
		}
	}
	
	override func create() {
		setScale(0.1)
		let appear = SKAction.scaleTo(1.5, duration: 0.5)
		runAction(appear, completion: { () -> Void in
			self.setScale(1.0)
		})
		
		Screen.currentScene!.player!.energy += 10
	}
	
	override func destroy() {
		StageMap.mainMap.trees.removeAtIndex(StageMap.mainMap.trees.indexOf(self)!)
		let vanish = SKAction.scaleTo(0.1, duration: 1.0)
		runAction(vanish) { () -> Void in
			self.removeFromParent()
		}
	}
}