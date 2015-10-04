//
//  Dark.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Dark : MapObject {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setBasics()
	}
	
	init() {
		let texture = SKTexture(imageNamed: "dark")
		super.init(texture: texture, color: UIColor.darkGrayColor(), size: texture.size() * 0.4)
		setBasics()
	}
	
	func setBasics() {
		colorBlendFactor = 1
		zPosition = 20000
	}
	
	override func beginFlood(stageMap: StageMap) {
		stageMap.floodPossible[mapPosition.y][mapPosition.x] = false
		stageMap.alterAtom(mapPosition, multiplier: 0.1, offset: 0)
		
		let fp = FloodPointer(inPosition: mapPosition, inDirection: 6, inStrength: 1.0)
		let dirs = fp.directions()
		
		for d in dirs {
			let p = fp.neighbour(d)
			stageMap.alterAtom(p, multiplier: 0.9, offset: 0.0)
		}
		
		
	}
	
	
}