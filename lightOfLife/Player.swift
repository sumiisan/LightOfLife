//
//  Player.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/08.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Player {
	var energy_:Luminosity = 0		//	happiness
	var maxEnergy:Luminosity = 1000
	private static var singleton:Player = Player()
	
	var energy:Luminosity {
		set(v) {
			energy_ = v
			if energy_ > maxEnergy {
				energy_ = maxEnergy
			}
			Screen.currentScene!.playerEnergyIndicator.currentValue = energy_
		}
		get {
			return energy_
		}
	}
	
	init() {
		Screen.currentScene!.playerEnergyIndicator.maxValue = maxEnergy
		energy = maxEnergy			//	TODO: charge energy when the first fluor is born
	}
	
	func update(currentTime: CFTimeInterval) {
		energy = energy + ( maxEnergy * 0.0001 )
		
	}
	
	
}
