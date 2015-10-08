//
//  MapObject.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015 sumiisan. All rights reserved.
//

import SpriteKit

enum MapObjectType {
	case Unknown
	case Light
	case Dark
	case Vine
	case Home
}

class MapObject : SKSpriteNode {
	
	var type:MapObjectType = .Unknown
	var mapPosition = IntPoint(x:0, y:0)

	func update( stageMap:StageMap ) {
		()
	}
	
	func create() {
		()
	}
	
	func destroy() {
		()
	}

}


