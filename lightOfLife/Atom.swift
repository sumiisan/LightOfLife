//
//  Atom.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Atom : SKSpriteNode {

	private var luminosity_:Luminosity = 0
	
	var luminosity:Luminosity {
		get {
			return luminosity_
		}
		set(lum) {
			luminosity_ = lum
			color = UIColor(hue: 0.0, saturation: 0.0, brightness: CGFloat(lum), alpha: 1.0)
		}
	}
	

	
	override init(texture: SKTexture?, color: UIColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
		setBasics()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setBasics()
	}
	
	func setBasics() {
		colorBlendFactor = 1.0
		zRotation = 0.2
		userInteractionEnabled = false
	}
	
	
	

}