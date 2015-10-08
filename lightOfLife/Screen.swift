//
//  Screen.swift
//  lightOfLife
//
//  Created by sumiisan on 2015/10/03.
//  Copyright © 2015年 sumiisan. All rights reserved.
//

import SpriteKit

class Screen {
	static let cellGap    = IntPoint( x: 35, y: 31 )
	static let cellOffset = IntPoint( x: 10, y: 15 )
	
	static var currentScene:GameScene?
	
	/*--------------------------------
	MARK:	- accessor and utils
	---------------------------------*/
	static func cellPosition( p:IntPoint ) -> CGPoint {
		let xShift = p.y % 2 == 0 ? 0 : CGFloat(cellGap.x) * 0.50
		return CGPointMake(
			CGFloat( p.x * cellGap.x + cellOffset.x ) + xShift,
			CGFloat( p.y * cellGap.y + cellOffset.y )
		)
	}
	
	static func cellIndex( p:CGPoint ) -> IntPoint {
		let y = ( Int(p.y) - cellOffset.y ) / cellGap.y
		let xShift = y % 2 == 0 ? 0 : CGFloat( cellGap.x ) * 0.50
		let x = ( Int(p.x) - cellOffset.x - Int( xShift ) ) / cellGap.x
		return IntPoint( x: x, y: y )
	}
	
	
	
}