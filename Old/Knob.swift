//
//  Knob.swift
//  Old
//
//  Created by Pedro Cacique on 10/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import SpriteKit

public class Knob: SKShapeNode{
    
    var radius: CGFloat
    var isRotating: Bool = false
    
    init( radius: CGFloat = 10, color: UIColor) {
        self.radius = radius
        super.init()
        self.setRadius(radius)
        self.fillColor = color
    }
    
    func setRadius(_ r: CGFloat){
        self.radius = r
        self.path = CGPath(ellipseIn:CGRect(x:self.position.x - radius, y:self.position.y - radius, width: 2 * radius, height: 2 * radius), transform: nil)
        
        let indicator:SKShapeNode = SKShapeNode(circleOfRadius: radius/5)
        indicator.fillColor = UIColor.black.withAlphaComponent(0.2)
        indicator.position = CGPoint(x:0, y:radius - radius/5 - radius/10)
        self.addChild(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
