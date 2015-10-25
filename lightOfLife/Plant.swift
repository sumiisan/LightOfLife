//
//  Plant.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/07.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

enum PlantType {
	case Indifferent
	case Flower
	case Tree
	case Vine
}

class Plant : MapObject {
	var stage:Double = 0.0
	var plantType:PlantType = .Indifferent
	var starved = false
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setBasics()
	}
	
	init() {
		super.init(texture: nil, color: UIColor.whiteColor(), size: CGSizeZero)
		setBasics()
	}
	
	private func imageNameForCurrentStage() -> String {
		var name:String?
		var st = Int(stage)
		if (st > 4) {
			st = 4
		}
		switch plantType {
		case .Flower://0       1        2        3 <--   4
			name = ["grass","flower","flower","wiltedFlower","flower"][st]
		case .Tree:
			name = ["grass","youngTree","tree","treeWithFruit","treeFallenFruit"][st]
		default:
			()
		}
		//	TODO:starved state
		
		
		return name!
	}
	
	private func setCurrentTexture() {
		texture = SKTexture(imageNamed: imageNameForCurrentStage())
		size = texture!.size() * 0.4
	}
	
	private func setBasics() {
		type = .Plant
		plantType = [.Flower,.Tree][2.randomNumber()]
		setCurrentTexture()
		colorBlendFactor = 1
		zPosition = 20000
	}
	
	override func update(stageMap: StageMap) {
		let fp = FloodPointer(inPosition: mapPosition, inDirection: 6, inStrength: 1.0)
		let dirs = fp.directions()
		let multiplier = plantType == PlantType.Flower ? 1.01 : 1.00
		stageMap.alterAtom(mapPosition, multiplier: multiplier, offset: 0.001)
		for d in dirs {
			stageMap.alterAtomWithPositionRangeCheck(fp.neighbour(d), multiplier: multiplier, offset: 0)	//	slower decay
		}
		let lastStage = Int(stage)
		var lum10 = stageMap.cell(mapPosition).lastFrameLuminosity * 10
		if ( lum10 > 8 ) {
			lum10 = 8
		}
		stage += 0.0005 * lum10
		if ( stage >= 5 ) {
			stage = plantType == PlantType.Flower ? 3 : 4
		}
		if ( Int(stage) != lastStage ) {
			setCurrentTexture()
		}
	}
	
	override func create() {
		setScale(0.1)
		let appear = SKAction.scaleTo(1.5, duration: 0.5)
		runAction(appear, completion: { () -> Void in
			self.setScale(1.0)
		})
		Actors.daddy.energy += 10
	}
	
	override func destroy() {
		StageMap.mainMap.plants.removeAtIndex(StageMap.mainMap.plants.indexOf(self)!)
		let vanish = SKAction.scaleTo(0.1, duration: 1.0)
		runAction(vanish) { () -> Void in
			self.removeFromParent()
		}
	}
}