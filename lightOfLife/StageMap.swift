//
//  StageMap.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015 sumiisan. All rights reserved.
//

import SpriteKit

struct Cell {
	var atom:Atom
	var object:MapObject?
	var floodable:Bool
	var lastFrameLuminosity:Luminosity
	
	mutating func saveLuminosity() {
		lastFrameLuminosity = atom.luminosity
		floodable = true
	}
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
	internal var cells  = [[Cell]]()
	internal var lights = [Light]()
	internal var darks  = [Dark]()
	
	/*--------------------------------
	MARK:	- initialization -
	---------------------------------*/
	private static var singleton_:StageMap? = nil
	
	internal static var mainMap:StageMap {
		get {
			if StageMap.singleton_ == nil {
				StageMap.singleton_ = StageMap()
			}
			return StageMap.singleton_!
		}
	}

	init() {
		StageMap.singleton_ = self
		for _ in 0..<mapSize.height {
			var row = [Cell]()
			for _ in 0..<mapSize.width {
				let atom = Atom(imageNamed:"atom")
				atom.luminosity = 0.0
				row.append(Cell(atom: atom, object: nil, floodable: true, lastFrameLuminosity: 0))
			}
			cells.append(row)
		}
		
		for _ in 0..<maxLightCount {
			let light = Light()
			placeMapObject(light, at: searchUnreservedCellWithMargin( 2 ))
			lights.append(light)
		}
		
		for _ in 0..<maxDarkCount {
			let dark = Dark()
			placeMapObject(dark, at: searchUnreservedCellWithMargin( 1 ))
			darks.append(dark)
		}
		
		lights[0].state = LightStates.On	//	turn first light on
		lights[0].covered = false
	}
	
	/*-------------------------------------------
	MARK:	- objects
	--------------------------------------------*/
	func placeMapObject( object:MapObject, at position:IntPoint ) {
		cells[position.y][position.x].object = object
		object.mapPosition = position
	}
	
	final internal func objectAt( position:IntPoint ) -> MapObject? {
		return cells[position.y][position.x].object
	}
	
	func searchUnreservedCellWithMargin( margin:Int ) -> IntPoint {
		while( true ) {
			let p = randomPositionWithEdgeMargin(margin)
			if cells[p.y][p.x].object == nil {
				return p
			}
		}
	}
	
	/*-------------------------------------------
	MARK:	- temporary map related buffers
	--------------------------------------------*/
	func saveFrameLuminosity() {
//		let _ = flatMap(cells){ Cell($0).saveLuminosity() }	//	causes compiler seg-fault!
//		let _ = map(cells){($0 as [Cell]).map{($0 as Cell).saveLuminosity()}}		//	causes compiler seg-fault too!
		for y in 0..<mapSize.height {
			for x in 0..<mapSize.width {
				cells[y][x].saveLuminosity()
			}
		}
	}
	
	/*--------------------------------
	MARK:	- map access
	---------------------------------*/
	func alterAtom( position:IntPoint, multiplier:Double, offset:Double ) {
		cells[position.y][position.x].atom.luminosity
			= cells[position.y][position.x].atom.luminosity * multiplier + offset
	}
	
	func alterAtomWithPositionRangeCheck( position:IntPoint, multiplier:Double, offset:Double ) -> Bool {
		if positionIsInsideMap( position ) {
			cells[position.y][position.x].atom.luminosity
				= cells[position.y][position.x].atom.luminosity * multiplier + offset
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
