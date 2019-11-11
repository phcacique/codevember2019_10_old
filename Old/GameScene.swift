//
//  GameScene.swift
//  Old
//
//  Created by Pedro Cacique on 10/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var screen:SKShapeNode = SKShapeNode(rect: CGRect(x:0, y:0, width:0, height:0))
    var screenBorder:SKShapeNode = SKShapeNode(rect: CGRect(x:0, y:0, width:0, height:0))
    let border:CGFloat = 40
    var leftKnob:Knob = Knob(radius: 10, color: .white)
    var rightKnob:Knob = Knob(radius: 10, color: .white)
    
    var knobColor:UIColor = UIColor(red:240/255, green:240/255, blue:240/255, alpha:1)
    var bgColor:UIColor = UIColor(red:214/255, green:48/255, blue:49/255, alpha:1)
    var screenColor:UIColor = UIColor(red:206/255, green:206/255, blue:206/255, alpha:1)
    var strokeColor:UIColor = UIColor(red:20/255, green:20/255, blue:20/255, alpha:1)
    var labelColor:UIColor = UIColor(red:253/255, green:203/255, blue:110/255, alpha:1)

    var activeTouches = [UITouch:String]()
    var movingPoint:CGPoint = .zero

    override func didMove(to view: SKView) {
        backgroundColor = bgColor
        
        //SCREEN
        let w = self.size.width - 2 * border
        let h = self.size.height - 100 - border
        screen = SKShapeNode(rect: CGRect(x:border, y:self.size.height - border - h, width:w, height:h), cornerRadius: 10)
        screen.fillColor = screenColor
        screen.lineWidth = 0
        addChild(screen)
        
        screenBorder = SKShapeNode(rect: CGRect(x:border, y:self.size.height - border - h, width:w, height:h), cornerRadius: 10)
        screenBorder.strokeColor = bgColor
        screenBorder.lineWidth = 10
        addChild(screenBorder)
        screenBorder.zPosition = CGFloat(self.children.count + 1)
        
        //LEFT KNOB
        leftKnob = Knob(radius: 30, color: knobColor)
        leftKnob.position = CGPoint(x:border + leftKnob.frame.size.width/2, y:border/2 + leftKnob.frame.size.height/2)
        leftKnob.zRotation = .pi/2
        addChild(leftKnob)
        
        //RIGHT KNOB
        rightKnob = Knob(radius: 30, color: knobColor)
        rightKnob.position = CGPoint(x:self.size.width - border - leftKnob.frame.size.width/2, y:leftKnob.position.y)
        addChild(rightKnob)
        
        //LINE
        movingPoint = CGPoint(x: screen.frame.minX, y:screen.frame.midY)
        
        //TITLE
        let label:SKLabelNode = SKLabelNode(text: "iSketch")
        label.horizontalAlignmentMode = .center
        label.fontName = "SachieScript"
        label.fontColor = labelColor
        label.fontSize = 60.0
        label.position = CGPoint(x:self.size.width/2, y: border)
        addChild(label)
    }
    
    func moveLeftRight(_ value:CGFloat){
        
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: movingPoint)

        let newX:CGFloat = ((value / 180) * (screen.frame.maxX - screen.frame.minX)) + screen.frame.minX
        
        let newPoint:CGPoint = CGPoint(x:newX, y:movingPoint.y)
        path.addLine(to: newPoint)
        
        line.path = path
        line.strokeColor = strokeColor
        addChild(line)
        movingPoint = newPoint
        screenBorder.zPosition = CGFloat(self.children.count + 1)
    }
    
    func moveUpDown( _ value:CGFloat ){
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: movingPoint)
        
        let newY:CGFloat = ((value / 180) * (screen.frame.maxY - screen.frame.minY)) + screen.frame.minY
        
        let newPoint:CGPoint = CGPoint(x:movingPoint.x, y:newY)
        path.addLine(to: newPoint)
        
        line.path = path
        line.strokeColor = strokeColor
        addChild(line)
        movingPoint = newPoint
        screenBorder.zPosition = CGFloat(self.children.count + 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if leftKnob.contains(location) {
                leftKnob.isRotating = true
                activeTouches[touch] = "left"
            } else if rightKnob.contains(location) {
                rightKnob.isRotating = true
                activeTouches[touch] = "right"
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if activeTouches[touch] == "left" {
                let dy = location.y - leftKnob.position.y
                let dx = location.x - leftKnob.position.x
                let angle = CGFloat(atan2f(Float(dy), Float(dx))) - .pi/2
                let angle2 = ((angle >= 0) ? angle : (.pi + (.pi + angle))) * 180 / .pi
                if (angle2 > 0 && angle2 <= 90) || (angle2 > 270 && angle2 <= 360){
                    var value:Int = 0
                    if angle2 <= 90{
                        value = 90 - Int(angle2)
                    } else if angle2 > 270{
                        value = 450 - Int(angle2)
                    }
                    rotateKnobTo(angle: angle, knob: leftKnob)
                    moveLeftRight(CGFloat(value))
                }
                
                
            } else if activeTouches[touch] == "right" {
                
                let dy = location.y - rightKnob.position.y
                let dx = location.x - rightKnob.position.x
                let angle = CGFloat(atan2f(Float(dy), Float(dx))) - .pi/2
                let angle2 = ((angle >= 0) ? angle : (.pi + (.pi + angle))) * 180 / .pi
                if (angle2 > 0 && angle2 <= 90) || (angle2 > 270 && angle2 <= 360){
                    var value:Int = 0
                    if angle2 <= 90{
                        value = 90 - Int(angle2)
                    } else if angle2 > 270{
                        value = 450 - Int(angle2)
                    }
                    rotateKnobTo(angle: angle, knob: rightKnob)
                    moveUpDown(CGFloat(value))
                }
            }
        }
    }
    
    func rotateKnobTo(angle targetAngle: CGFloat, knob:Knob) {
        let rotateAction = SKAction.rotate(toAngle: targetAngle, duration: 0.1 , shortestUnitArc: true)
        knob.run(rotateAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if activeTouches[touch] == "left" {
                leftKnob.isRotating = false
                activeTouches[touch] = nil
            } else if activeTouches[touch] == "right" {
                rightKnob.isRotating = false
                activeTouches[touch] = nil
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if activeTouches[touch] == "left" {
                leftKnob.isRotating = false
                activeTouches[touch] = nil
            } else if activeTouches[touch] == "right" {
                rightKnob.isRotating = false
                activeTouches[touch] = nil
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

