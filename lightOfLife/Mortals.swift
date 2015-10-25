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
			if ( e < maxEnergy ) {
				energy_ = e
			} else {
				energy_ = maxEnergy
			}
		}
	}
	var maxEnergy:Luminosity = 1000		//	happiness capacity
	var tension:Tension = 0.5			//	how excited he is		0...1
	
	var baseSize:Double = 0.7			//	daddy
	private var sinPhase:Double = 0
	
	func update(currentTime: CFTimeInterval) {
		sinPhase += tension * 0.15
		setScale(CGFloat(sin(sinPhase) * 0.1 + baseSize))
	}
	
	
	
	
}