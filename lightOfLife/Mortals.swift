//
//  Mortals.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/24.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import Foundation
import SpriteKit

class Mortals: SKSpriteNode {
	
	
/*

MARK:	- instance vars -
	
*/
	var energy_:Luminosity = 0			//	happiness for player(parent) and child
	var energy:Luminosity {
		get {
			return energy_
		}
		set(e) {
			energy_ = e
		}
	}
	var maxEnergy:Luminosity = 1000		//	happiness capacity
	var tension:Tension = 0.5			//	how excited he is		0...1
	
	
	
	
	
	
}