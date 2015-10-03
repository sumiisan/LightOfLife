//
//  StageMap.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class StageMap {
	/*--------------------------------
	MARK:	- constants -
	---------------------------------*/
	internal let mapSize = IntSize(width: 12, height: 20)
	internal let maxLightCount = 5
	
	/*--------------------------------
	MARK:	- variables -
	---------------------------------*/
	internal var atoms = [[Atom]]()
	internal var lastFramesLuminosity = [[Luminosity]]()
	internal var floodScannedWithStrength = [[Double]]()
	internal var lights = [Light]()
	
	init() {
		for _ in 0..<mapSize.height {
			var row = [Atom]()
			for _ in 0..<mapSize.width {
				let atom = Atom(imageNamed:"atom")
				atom.luminosity = 0.0
				row.append(atom)
			}
			atoms.append(row)
		}
		
		for _ in 0..<maxLightCount {
			let light = Light(circleOfRadius: 15.0)
			light.mapPosition = randomPositionWithEdgeMargin(3)
			lights.append(light)
		}
		
		lights[0].state = LightStates.On	//	turn first light on
	}
	
	
	func alterAtom( position:IntPoint, multiplier:Double, offset:Double ) {
		atoms[position.y][position.x].luminosity = atoms[position.y][position.x].luminosity * multiplier + offset
	}
	
	func alterAtomWithPositionRangeCheck( position:IntPoint, multiplier:Double, offset:Double ) -> Bool {
		if positionIsInsideMap( position ) {
			atoms[position.y][position.x].luminosity = atoms[position.y][position.x].luminosity * multiplier + offset
			return true
		}
		return false
	}
	
	final private func positionIsInsideMap( position:IntPoint ) -> Bool {
		return position.x >= 0
			&& position.x < mapSize.width
			&& position.y >= 0
			&& position.y < mapSize.height
	}

	func randomPositionWithEdgeMargin( margin:Int ) -> IntPoint {
		let x = Random.integer( mapSize.width  - margin * 2 ) + margin
		let y = Random.integer( mapSize.height - margin * 2 ) + margin
		return IntPoint( x: Int(x), y:Int(y) )
	}

	func saveFrameLuminosity() {
		lastFramesLuminosity = [[Luminosity]]()
		floodScannedWithStrength = [[Double]]()
		for y in 0..<mapSize.height {
			var row = [Luminosity]()
			for x in 0..<mapSize.width {
				let atom = atoms[y][x]
				row.append(atom.luminosity)
			}
			lastFramesLuminosity.append(row)
			floodScannedWithStrength.append([Double](count: mapSize.width, repeatedValue: 0.0))
		}
	}
	
}
