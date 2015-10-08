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


/*--------------------------------
MARK:	- integer size
---------------------------------*/

struct IntSize {
	var width:Int
	var height:Int
}

/*--------------------------------
MARK:	- integer point
---------------------------------*/

struct IntPoint {
	var x:Int
	var y:Int
}

func == (left: IntPoint, right: IntPoint) -> Bool {
	return (left.x == right.x) && (left.y == right.y)
}

func != (left: IntPoint, right: IntPoint) -> Bool {
	return (left.x != right.x) || (left.y != right.y)
}


