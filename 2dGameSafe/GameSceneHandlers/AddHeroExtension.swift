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
}
