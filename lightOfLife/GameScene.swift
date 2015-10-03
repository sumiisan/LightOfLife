//
//  GameScene.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright (c) 2015年 sumiisan. All rights reserved.
//
import Foundation
import SpriteKit


class GameScene: SKScene {
	/*--------------------------------
	MARK:	- constants -
	---------------------------------*/
	let mapSize = IntSize(width: 12, height: 20)
	/*--------------------------------
	MARK:	- variables -
	---------------------------------*/
	var map = [[MapEntity]]()
	var lights = [Light]()
	
	/*--------------------------------
	MARK:	- initialization -
	---------------------------------*/
    override func didMoveToView(view: SKView) {
		
		
	
		map = [[MapEntity]]()
		
		//	init atom map
		let xGap = 35
		let yGap = 31
		
		for y in 0..<mapSize.height {
			var row = [MapEntity]()
			for x in 0..<mapSize.width {
//				let l:CGFloat = CGFloat(arc4random_uniform(11)) / 10
				let luminosity = 0.2
				let atom = Atom(imageNamed:"atom")
				let xShift = y % 2 == 0 ? 0 : CGFloat(xGap) * 0.50
				atom.position = CGPointMake( CGFloat( x * xGap ) + 320 + xShift,
											 CGFloat( y * yGap ) + 100)
				
				atom.luminosity = luminosity
				addChild(atom)
				let mapEntity = MapEntity(atom:atom)
				row.append(mapEntity)
			}
			map.append(row)
		}
	}

	/*--------------------------------
	MARK:	- interaction -
	---------------------------------*/

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
    }
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let node = nodeAtPoint(touches.first!.locationInNode(self))
		if let atom:Atom = node as? Atom {
			atom.luminosity = 1.0
		}
	}
   
	/*--------------------------------
	MARK:	- update -
	---------------------------------*/
    override func update(currentTime: CFTimeInterval) {
		//	darken every atom
		for y in 0..<mapSize.height {
			for x in 0..<mapSize.width {
				map[y][x].atom!.luminosity *= 0.7
			}
		}
		

	}
	
	
	
	
	
	
	
}
