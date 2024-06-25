//
//  AddHeroExtension.swift
//  BitRayed
//
//  Created by Ali Haidar on 20/06/24.
//

import SpriteKit

extension GameScene {
    func addHero() {
        hero = childNode(withName: "character") as! SKSpriteNode
        hero.zPosition = 50
        hero.physicsBody = SKPhysicsBody(texture: hisTexture, size: hero.size)
        hero.physicsBody?.categoryBitMask = bitMasks.hero.rawValue
        hero.physicsBody?.contactTestBitMask = bitMasks.wall.rawValue | bitMasks.bed.rawValue
        hero.physicsBody?.collisionBitMask = bitMasks.wall.rawValue | bitMasks.bed.rawValue
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.allowsRotation = false
        hero.texture?.filteringMode = .nearest
        hero.name = "character"
        actionSign = SKSpriteNode(imageNamed: "actionSign")
        actionSign.size = CGSize(width: 5, height: 15)
        actionSign.zPosition = 50
        actionSign.position = CGPoint(x: -10, y: 15)
        actionSign.isHidden = true
        actionSign.name = "actionSign"
        hero.addChild(actionSign)
    }
    
    func addPolice() {
        police = childNode(withName: "police") as! SKSpriteNode
        police.zPosition = 51
        police.name = "police"
    }
    
    func addPoliceMovement() {
        let initialPosition = police.position
        let boxWidth: CGFloat = 150.0
        let boxHeight: CGFloat = 50
        
        let topLeft = CGPoint(x: initialPosition.x, y: initialPosition.y + boxHeight)
        let topRight = CGPoint(x: initialPosition.x + boxWidth, y: initialPosition.y + boxHeight)
        let bottomLeft = CGPoint(x: initialPosition.x, y: initialPosition.y)
        let bottomRight = CGPoint(x: initialPosition.x + boxWidth, y: initialPosition.y)
        
        let moveToTopLeft = SKAction.move(to: topLeft, duration: 2.0)
        let moveToTopRight = SKAction.move(to: topRight, duration: 6.0)
        let moveToBottomRight = SKAction.move(to: bottomRight, duration: 2.0)
        let moveToBottomLeft = SKAction.move(to: bottomLeft, duration: 6.0)
        
        let moveSequence = SKAction.sequence([moveToTopLeft, moveToTopRight, moveToBottomRight, moveToBottomLeft])
        let repeatMovement = SKAction.repeatForever(moveSequence)
        
        police.run(repeatMovement, withKey: "boxMovement")
    }
}
