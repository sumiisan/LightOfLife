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
	
	init() {
				Actors.daddy.energy = Actors.daddy.maxEnergy			//	TODO: charge energy when the first fluor is born
	}
	
	func update(currentTime: CFTimeInterval) {
		let daddy = Actors.daddy
		daddy.energy += ( daddy.maxEnergy * 0.0001 )
		
	}
	
	
	
	
}
