//
//  Atom.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

struct HueAndSaturation {
	var hue:CGFloat
	var saturation:CGFloat
	
	func colorWithLuminosity( lum:Luminosity ) -> UIColor {
		return UIColor(hue: hue, saturation: saturation, brightness: CGFloat(lum <= 1 ? lum * 0.7: 0.7), alpha: 1.0)
	}
}

typealias AtomStage = Int

let AtomGrade_Field = 3
let AtomGrade_Wood = 5
let AtomGrade_Stream = 6

class Atom : SKSpriteNode {
	private var luminosity_:Luminosity = 0
	internal var grade:Int = 0
	private var fluorPassedCount_:Int = 0
	private var fluorPassedCount:Int {
		get {
			return fluorPassedCount_
		}
		set(c) {
			if ( c >= 0 ) {
				fluorPassedCount_ = c
				grade = fluorPassedCount <= 9 ? fluorPassedCount : 9
			}
		}
	}
	
	private let baseColors = [
		HueAndSaturation(hue: 0.0, saturation: 0.0),		//	0:void
		HueAndSaturation(hue: 0.2, saturation: 0.2),		//	1:path 1
		HueAndSaturation(hue: 0.3, saturation: 0.3),		//	2:path 2
		HueAndSaturation(hue: 0.4, saturation: 0.4),		//	3:field 1
		HueAndSaturation(hue: 0.5, saturation: 0.4),		//	4:field 2
		HueAndSaturation(hue: 0.6, saturation: 0.5),		//	5:wood
		HueAndSaturation(hue: 0.7, saturation: 0.5),		//	6:stream 1
		HueAndSaturation(hue: 0.7, saturation: 0.6),		//	7:stream 2
		HueAndSaturation(hue: 0.7, saturation: 0.7),		//	8:stream 3
		HueAndSaturation(hue: 0.7, saturation: 0.8),		//	9:stream 4
	]
	
	func pass() {
		++fluorPassedCount
	}
	
	func degrade() {
		--fluorPassedCount
	}
	
	var luminosity:Luminosity {
		get {
			return luminosity_
		}
		set(lum) {
			luminosity_ = lum
			color = baseColors[grade].colorWithLuminosity(lum)
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