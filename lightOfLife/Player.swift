//
//  Player.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/08.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Player {
	var energy_:Luminosity = 0		//	happiness  	TODO: charge energy when the first fluor is born
	var maxEnergy:Luminosity = 1000
	
	var energy:Luminosity {
		set(v) {
			energy_ = v
			Screen.currentScene!.playerEnergyIndicator.currentValue = v
		}
		get {
			return energy_
		}
	}
	
	init() {
		Screen.currentScene!.playerEnergyIndicator.maxValue = maxEnergy
		energy = maxEnergy			//	happiness  	TODO: charge energy when the first fluor is born
	}
	
	
}
