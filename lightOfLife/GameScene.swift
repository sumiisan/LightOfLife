//
//  GameScene.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright (c) 2015 sumiisan. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene {
	var stageMap:StageMap = StageMap()
	var avatar:Avatar = Avatar()

	
	/*--------------------------------
	MARK:	- initialization -
	---------------------------------*/
    override func didMoveToView(view: SKView) {
		//	init atom map
		let width  = stageMap.mapSize.width
		let height = stageMap.mapSize.height
		
		avatar.mapPosition = stageMap.lights[0].mapPosition
		
		for y in 0..<height {
			for x in 0..<width {
				let atom = stageMap.cells[y][x].atom
				atom.position = Screen.cellPosition( IntPoint( x:x, y:y ) )
				addChild(atom)
			}
		}
		
		for light in stageMap.lights {
			light.position = Screen.cellPosition( light.mapPosition )
			addChild(light)
		}

		for dark in stageMap.darks {
			dark.position = Screen.cellPosition( dark.mapPosition )
			addChild(dark)
		}
		
		addChild(avatar.destinationMark)
		addChild(avatar)
		
	}
	
	/*--------------------------------
	MARK:	- interaction -
	---------------------------------*/
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		//processTouches(touches, withEvent: event)
    }
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		processTouches(touches, withEvent: event)
	}
	
	func processTouches(touches:Set<UITouch>, withEvent event:UIEvent?) {
		for touch in touches {
			let node = nodeAtPoint(touch.locationInNode(self))
			if let atom:Atom = node as? Atom {
				atom.luminosity = atom.luminosity < 2.0 ? atom.luminosity * 2 + 0.4 : 2.0
				let ci = Screen.cellIndex(atom.position)
				stageMap.uncoverObjectsAt(ci)
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
		
		//	decay
		for y in 0..<height {
			for x in 0..<width {
				
//				stageMap.alterAtom(IntPoint(x:x,y:y), multiplier: 0.9, offset: 0)
				var l = stageMap.cells[y][x].atom.luminosity * 0.9
				if l > 4 {
					l = 4
				}
				stageMap.cells[y][x].atom.luminosity = l
			}
		}
		stageMap.saveFrameLuminosity()
		
		for d in stageMap.darks {
			d.update(stageMap)
		}
		
		let shuffledLights = stageMap.lights.shuffle()

		for l in shuffledLights {
			l.update(stageMap)
		}
		
		avatar.beginFlood(stageMap)
	}
}



