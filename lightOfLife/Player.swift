//
//  Player.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/08.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Player {
	private static var singleton:Player = Player()
	
	func update(currentTime: CFTimeInterval) {
		let daddy = Actors.daddy
		daddy.energy += ( daddy.maxEnergy * 0.0001 )
	}
	
	
	
	
}
