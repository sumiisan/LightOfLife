//
//  StageMap.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015 sumiisan. All rights reserved.
//

import SpriteKit


/*--------------------------------



MARK:	- STAGE MAP -



---------------------------------*/

class StageMap {
	/*--------------------------------
	MARK:	- constants
	---------------------------------*/
	internal let mapSize = IntSize(width: 9, height: 18)
	internal let maxLightCount = 1
	internal let maxDarkCount =  1

	/*--------------------------------
	MARK:	- objects
	---------------------------------*/
	internal var cells  = [[MapCell]]()
	internal var lights = [Light]()
	internal var darks  = [Dark]()
	internal var plants  = [Plant]()
	
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
			var row = [MapCell]()
			for _ in 0..<mapSize.width {
				let atom = Atom(imageNamed:"atom2")
				atom.luminosity = 0.0
				row.append(MapCell(
					atom: atom,
					object: nil,
					floodable: true,
					lastFrameLuminosity: 0
				))
			}
			cells.append(row)
		}
		
		
/*
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
*/
		
		
		
		lights[0].touch()	//	turn first light on
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
	func processCells() {
		for y in 0..<mapSize.height {
			for x in 0..<mapSize.width {
				let upgradeable = cells[y][x].decay()
				if upgradeable {
					let neighbour = HexGrid(pos: IntPoint(x: x,y: y)).neighbour(6.randomNumber())
					let cell = cellWithPositionRangeCheck(neighbour)
					if cell != nil && cell!.atom.grade < AtomGrade_Wood {
						cell!.atom.pass()
					}
				}
				let grade = cells[y][x].atom.grade
				if grade >= AtomGrade_Field && grade < AtomGrade_Stream {
					if 600.randomNumber() == 0 {
						//	spawn items and objects
						let tree = spawn(MapObjectType.Plant, at:IntPoint(x: x, y: y))
						if let spawnedPlant = tree as? Plant {
							plants.append(spawnedPlant)
							Screen.currentScene?.addObjectToScene(spawnedPlant)
							spawnedPlant.create()
						}
					}
				}
			}
		}
	}
	
	func spawn(objectType:MapObjectType, at position:IntPoint ) -> MapObject? {
		//	do not put multiple objects on a cell (for now)
		if cells[position.y][position.x].object == nil {
			let obj = newObjectOfType(objectType)!
			placeMapObject(obj, at: position)
			return obj
		}
		return nil
	}
	
	func newObjectOfType(objectType:MapObjectType) -> MapObject? {
		switch( objectType ) {
		case .Light:
			return Light()
		case .Dark:
			return Dark()
		case .Plant:
			return Plant()
		default:
			return nil
		}
	}
	
	func saveFrameLuminosity() {
//		let _ = flatMap(cells){ Cell($0).saveLuminosity() }	//	causes compiler seg-fault!
//		let _ = map(cells){($0 as [Cell]).map{($0 as Cell).saveLuminosity()}}		//	causes compiler seg-fault too!
		for y in 0..<mapSize.height {
			for x in 0..<mapSize.width {
				cells[y][x].saveLuminosity()
			}
		}
	}
	
	func update() {
		for d in darks {
			d.update(self)
		}
		
		for p in plants {
			p.update(self)
		}
		
		let shuffledLights = lights.shuffle()
		
		for l in shuffledLights {
			l.update(self)
		}
	}
	
	/*--------------------------------
	MARK:	- map access
	---------------------------------*/
	func cell( pos:IntPoint ) -> MapCell {
		return cells[pos.y][pos.x]
	}
	
	func cellWithPositionRangeCheck( position:IntPoint ) -> MapCell? {
		if positionIsInsideMap(position) {
			return cells[position.y][position.x]
		}
		return nil
	}
	
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
	
	final func positionIsInsideMap( position:IntPoint ) -> Bool {
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
