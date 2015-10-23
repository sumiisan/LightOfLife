//
//  BarIndicator.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/08.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class BarIndicator : SKShapeNode {
	
	private var bar:SKShapeNode?
	private var currentValue_:Double = 0
	private var displayValue:Double = 0		//	TODO:animate bar 
	
	private var barColor_:UIColor = UIColor.colorWithHex(0xFFFF44)
	
	internal var varColor:UIColor {
		get {
			return barColor_
		}
		set(c) {
			barColor_ = c
			bar!.fillColor = c
		}
	}
	
	var maxValue:Double = 1
	var currentValue:Double {
		set(v) {
			currentValue_ = v
			let p = CGFloat( currentValue / maxValue )
			bar!.path = UIBezierPath(
				rect: CGRectMake(1+frame.minX, 1+frame.minY, p * (frame.width - 2), frame.height-2)).CGPath
		}
		get {
			return currentValue_
		}
	}
	
	init( inFrame:CGRect) {
		super.init()
		path = UIBezierPath(rect: inFrame).CGPath
		lineWidth = 0.5
		strokeColor = UIColor.colorWithHex(0x44CC88)
		bar = SKShapeNode.init(rect: CGRectZero)
		zPosition = 1000000
		bar!.fillColor = barColor_
		bar!.strokeColor = UIColor.clearColor()
		addChild(bar!)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	
	
	
}
