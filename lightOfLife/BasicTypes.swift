//
//  BasicTypes.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import Foundation
import SpriteKit


typealias Luminosity = Double

struct MapEntity {
	var atom:Atom?
}

struct IntSize {
	var width:Int
	var height:Int
}

struct IntPoint {
	var x:Int
	var y:Int
}
