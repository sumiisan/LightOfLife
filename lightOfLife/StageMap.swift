//
//  StageMap.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

struct Cell {
	var atom:Atom
	var object:MapObject
	var floodable:Bool
	var lastFrameLuminosity:Luminosity
}

class StageMap {
	/*--------------------------------
	MARK:	- constants
	---------------------------------*/
	internal let mapSize = IntSize(width: 12, height: 20)
	internal let maxLightCount = 5
	internal let maxDarkCount = 10
	
	/*--------------------------------
	MARK:	- objects
	---------------------------------*/
	internal var atoms  = [[Atom]]()
//	internal var cells  = [[Cell]]()
	internal var lights = [Light]()
	internal var darks  = [Dark]()
	
	
	/*--------------------------------
	MARK:	- initialization -
	---------------------------------*/
	
	private var singleton_:StageMap? = nil
	
	internal var singleton:StageMap {
		get {
			if singleton_ == nil {
				singleton_ = StageMap()
			}
			return singleton_!
		}
	}

	
	init() {
		singleton_ = self
		for _ in 0..<mapSize.height {
			var row = [Atom]()
			for _ in 0..<mapSize.width {
				let atom = Atom(imageNamed:"atom")
				atom.luminosity = 0.0
				row.append(atom)
			}
			atoms.append(row)
		}
		
		var reserve = [Bool](count: mapSize.width * mapSize.height, repeatedValue: false)
		
		for _ in 0..<maxLightCount {
			let light = Light()
			
			light.mapPosition = getUnreservedPosition( &reserve, margin: 3 )
			lights.append(light)
		}
		
		for _ in 0..<maxDarkCount {
			let dark = Dark()
			dark.mapPosition = getUnreservedPosition( &reserve, margin: 2 )
			darks.append(dark)
		}
		
		lights[0].state = LightStates.On	//	turn first light on
		lights[0].covered = false
	}
	
	/*-------------------------------------------
	MARK:	- temporary map related buffers
	--------------------------------------------*/
	internal var lastFramesLuminosity = [[Luminosity]]()
	internal var floodPossible = [[Bool]]()

	func indexForPoint( p:IntPoint ) -> Int {
		return p.y * mapSize.width + p.x
	}
	
	func getUnreservedPosition( inout reserve:[Bool], margin:Int ) -> IntPoint {
		while( true ) {
			let p = randomPositionWithEdgeMargin(margin)
			if !reserve[ indexForPoint(p) ] {
				reserve[ indexForPoint(p) ] = true
				return p
			}
		}
	}
	
	func saveFrameLuminosity() {
		lastFramesLuminosity = [[Luminosity]]()
		floodPossible = [[Bool]]()
		for y in 0..<mapSize.height {
			var row = [Luminosity]()
			for x in 0..<mapSize.width {
				let atom = atoms[y][x]
				row.append(atom.luminosity)
			}
			lastFramesLuminosity.append(row)
			floodPossible.append([Bool](count: mapSize.width, repeatedValue: true))
		}
	}
	

	
	/*--------------------------------
	MARK:	- map access
	---------------------------------*/
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

	/*--------------------------------
	MARK:	- object access
	---------------------------------*/
	
	func uncoverObjectsAt( point:IntPoint ) {
		for light in lights {
			if light.mapPosition == point {
				light.uncover()
			}
		}
	}


	/*--------------------------------
	MARK:	- utils
	---------------------------------*/
	func randomPositionWithEdgeMargin( margin:Int ) -> IntPoint {
		let x = ( mapSize.width  - margin * 2 ).randomNumber() + margin
		let y = ( mapSize.height - margin * 2 ).randomNumber() + margin
		return IntPoint( x: Int(x), y:Int(y) )
	}

	
}
