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

struct IntSize {
	var width:Int
	var height:Int
}

struct IntPoint {
	var x:Int
	var y:Int
}

class Random {
	static func integer( v:Int ) -> Int {
		return Int( arc4random_uniform( UInt32(v)) )
	}
}



