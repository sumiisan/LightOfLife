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
	var fluor:Fluor = Fluor()
	
	var playerEnergyIndicator:BarIndicator = BarIndicator(inFrame: CGRectMake(10, 20, 300, 10))
	var fluorEnergyIndicator:BarIndicator  = BarIndicator(inFrame: CGRectMake(10,550, 300, 10))
	
	var touchedCellPosition = IntPoint(x: -999,y: -999)

	var player:Player?
	
	/*--------------------------------
	MARK:	- initialization -
	---------------------------------*/

	
    override func didMoveToView(view: SKView) {
		//	init atom map
		let width  = stageMap.mapSize.width
		let height = stageMap.mapSize.height
		
		Screen.currentScene = self
		fluor.mapPosition = stageMap.lights[0].mapPosition
		
		for y in 0..<height {
			for x in 0..<width {
				let atom = stageMap.cells[y][x].atom
				atom.position = Screen.cellPosition( IntPoint( x:x, y:y ) )
				addChild(atom)
			}
		}
		
		for light in stageMap.lights {
			addObjectToScene(light)
		}

		for dark in stageMap.darks {
			addObjectToScene(dark)
		}
		
		addChild(fluor.destinationMark)
		addChild(fluor)
		
		player = Player()
	}
	
	
	func addObjectToScene( object:MapObject ) {
		object.position = Screen.cellPosition(object.mapPosition)
		addChild(object)
	}
	
	/*--------------------------------
	MARK:	- interaction -
	---------------------------------*/
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch = touches.first
		let node = nodeAtPoint(touch!.locationInNode(self))
		if let atom:Atom = node as? Atom {
			let ci = Screen.cellIndex(atom.position)
			touchedCellPosition = ci
		}
    }
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		checkTouchUp(touches.first!)
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		if let touch = touches?.first {
			checkTouchUp(touch)
		}
	}
	
	func checkTouchUp(touch:UITouch) {
		let node = nodeAtPoint(touch.locationInNode(self))
		if let atom = node as? Atom {
			let ci = Screen.cellIndex(atom.position)
			if  ci == touchedCellPosition {
				fluor.planMoveToCell(ci)
			}
		}
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
		stageMap.processCells()
		stageMap.saveFrameLuminosity()
		stageMap.update()
		fluor.beginFlood(stageMap)
	}
}



