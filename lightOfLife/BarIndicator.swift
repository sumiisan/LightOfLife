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
	
	var maxValue:Double = 1
	var currentValue:Double {
		set(v) {
			currentValue_ = v
			let p = CGFloat( currentValue / maxValue )
			bar?.path = UIBezierPath( rect: CGRectMake(1, 1, p * (frame.width - 2), frame.height-2)).CGPath
		}
		get {
			return currentValue_
		}
	}
	
	init( inFrame:CGRect) {
		super.init()
		path = UIBezierPath(rect: inFrame).CGPath
		lineWidth = 1
		strokeColor = UIColor.colorWithHex(0x44FF88)
		bar = SKShapeNode.init(rect: inFrame)
		bar!.fillColor = UIColor.colorWithHex(0x88FF44)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	
	
	
}
