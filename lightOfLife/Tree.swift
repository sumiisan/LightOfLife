//
//  Tree.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/07.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Tree : MapObject {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setBasics()
	}
	
	init() {
		let texture = SKTexture(imageNamed: "tree")
		super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size() * 0.45)
		setBasics()
	}
	
	private func setBasics() {
		type = .Tree
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
}