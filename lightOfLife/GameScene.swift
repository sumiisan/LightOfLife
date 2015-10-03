//
//  GameScene.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright (c) 2015年 sumiisan. All rights reserved.
//
import Foundation
import SpriteKit


class GameScene : SKScene {
	
	var stageMap:StageMap = StageMap()
	let xGap = 35
	let yGap = 31
	
	/*--------------------------------
	MARK:	- initialization -
	---------------------------------*/
    override func didMoveToView(view: SKView) {
		//	init atom map
		
		let width  = stageMap.mapSize.width
		let height = stageMap.mapSize.height
		
		for y in 0..<height {
			for x in 0..<width {
				let atom = stageMap.atoms[y][x]
				atom.position = cellPosition( IntPoint( x:x, y:y ) )
				addChild(atom)
			}
		}
		
		for light in stageMap.lights {
			light.position = cellPosition( light.mapPosition )
			addChild(light)
		}
	}
	/*--------------------------------
	MARK:	- accessor and utils -
	---------------------------------*/
	func cellPosition( p:IntPoint ) -> CGPoint {
		let xShift = p.y % 2 == 0 ? 0 : CGFloat(xGap) * 0.50
		return CGPointMake(
			CGFloat( p.x * xGap ) + 320 + xShift,
			CGFloat( p.y * yGap ) + 100
		)
	}

	/*--------------------------------
	MARK:	- interaction -
	---------------------------------*/

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
    }
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			let node = nodeAtPoint(touch.locationInNode(self))
			if let atom:Atom = node as? Atom {
				atom.luminosity = atom.luminosity < 2.0 ? atom.luminosity * 2 + 0.4 : 2.0
			}
		}
	}
   
	/*--------------------------------
	MARK:	- update -
	---------------------------------*/
    override func update(currentTime: CFTimeInterval) {
		//	darken every atom
		let width  = stageMap.mapSize.width
		let height = stageMap.mapSize.height
		
		for y in 0..<height {
			for x in 0..<width {
				stageMap.alterAtom(IntPoint(x:x,y:y), multiplier: 0.9, offset: 0)
//				stageMap.atoms[y][x].luminosity *= 0.9
			}
		}
		stageMap.saveFrameLuminosity()

		for l in stageMap.lights {
			l.beginFlood(stageMap)
		}

	}
	
	
	
	
	
	
	
}
