//
//  MapCell.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/07.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

/*--------------------------------



MARK:	- MAP CELL -



---------------------------------*/

struct MapCell {
	var atom:Atom
	var object:MapObject?
	var floodable:Bool
	var lastFrameLuminosity:Luminosity
	
	internal mutating func saveLuminosity() {
		lastFrameLuminosity = atom.luminosity
		floodable = true
	}
	
	internal func luminosity() -> Luminosity {
		return atom.luminosity
	}
	
	internal func doesStopAvatar() -> Bool {
		if( object != nil ) {
			if object!.type == MapObjectType.Light {
				return false
			}
			if object!.type == MapObjectType.Dark {
				return true
			}
		}
		return luminosity() < 0.4
	}
	
	internal mutating func decay() -> Bool {
		let l = atom.luminosity * 0.9
		atom.luminosity = l > Preference.MaxLuminosityOfCell ? Preference.MaxLuminosityOfCell : l
		
		/*
		approx chance to degrade
		
		if	lum < 0.1	1/600  for grade 1 .. 1/60  for grade 9
		if	lum = 0.9	1/6000 for grade 1 .. 1/600 for grade 9
		
		1 /	( 6000 / grade * lum ) chance
		
		*/
		let g = pow(Double(atom.grade+1), 2) / 10	//	1..10 -> 0.1..10
		if Int(6000.0 / g * l).randomNumber() == 0 {
			atom.degrade()
		}
		
		/*
		
		approx chance to upgrade
		
		if lum < 0.1	1/60000	for grade 1 .. 1/6000 for grade 9
		if lum = 0.9	1/6000  for grade 1 .. 1/600  for grade 9
		
		1 / ( 6000 / (lum+1) / grade ) chance
		
		*/
		
		//	 upgrade ?
		return Int(6000.0 / (l+1) / g).randomNumber() == 0
		
	}
	
}

