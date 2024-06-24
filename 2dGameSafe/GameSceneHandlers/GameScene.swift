//
//  GameScene.swift
//  BitRayed
//
//  Created by Ali Haidar on 20/06/24.
//

import Foundation
import SpriteKit
import AVFoundation
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var hero = SKSpriteNode()
    var stuff = SKSpriteNode()
    var actionSign = SKSpriteNode()
    let hisTexture = SKTexture(imageNamed: "character")
    var moveToLeft = false
    var moveToRight = false
    var moveUp = false
    var moveDown = false
    var actionButton = false
    var isInteract = false
    var cameraNode = SKCameraNode()
    var warningSign: SKSpriteNode!
    var heroNode: SKSpriteNode!
    
    var gameState: GameState?

    var contactManager: ContactManager!
    
    let collisionNames = ["bed", "drawer", "tv", "chest", "wardrobe", "file_cabinet", "safe", "pic_frame"]
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        setupCamera()
        
        addHero()
        
        addCollisions(names: collisionNames)
        
        contactManager = ContactManager(scene: self)
        
        for node in self.children {
            if(node.name == "wallPhysics") {
                if let someTileMap: SKTileMapNode = node as? SKTileMapNode {
                    tilePhysics(map: someTileMap)
//                    someTileMap.removeFromParent()
                }
                break
            }
        }
    }
    
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        cameraNode.xScale = 0.2
        cameraNode.yScale = 0.2
        camera = cameraNode
        addChild(cameraNode)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let touchNode = self.nodes(at: position)
            
            for node in touchNode {
                if node.name == "left" {
                    moveToLeft = true
                }
                if node.name == "right" {
                    moveToRight = true
                }
                if node.name == "up" {
                    moveUp = true
                }
                if node.name == "down" {
                    moveDown = true
                }
                if node.name == "interact" {
                    isInteract = true
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let touchNode = self.nodes(at: position)
            
            for node in touchNode {
                if node.name == "left" {
                    moveToLeft = false
                }
                if node.name == "right" {
                    moveToRight = false
                }
                if node.name == "up" {
                    moveUp = false
                }
                if node.name == "down" {
                    moveDown = false
                }
                if node.name == "interact" {
                    isInteract = false
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if moveToLeft {
            hero.position.x -= 2
        }
        if moveToRight {
            hero.position.x += 2
        }
        if moveUp {
            hero.position.y += 2
        }
        if moveDown {
            hero.position.y -= 2
        }
//        if actionButton && gameState!.bedTapable {
//            presentShadowViewController()
//        }
//        if actionButton && gameState!.drawerTapable {
//            presentDrawerViewController()
//        }
//        if actionButton && gameState!.chestTapable {
//            presentSafeViewController()
//        }
//        if actionButton && gameState!.tvTapable {
//            presentVentViewController()
//        }
//        if actionButton && gameState!.wardrobeTapable {
//            presentWardrobeViewController()
//        }
//        if actionButton && gameState!.cabinetTapable {
//            presentCabinetViewController()
//        }
//        if actionButton && gameState!.safeTapable {
//            presentCombLockViewController()
//        }
//        if actionButton && gameState!.picFrameTapable {
//            presentPictureHintViewController()
//        }
        
        if actionButton {
                    if let gameState = gameState {
                        if gameState.bedTapable {
                            print("Chest is tappable")
                            presentShadowViewController()
                        } else if gameState.drawerTapable {
                            print("Chest is tappable")
                            presentDrawerViewController()
                        } else if gameState.chestTapable {
                            print("Chest is tappable")
                            presentSafeViewController()
                        } else if gameState.tvTapable {
                            print("Chest is tappable")
                            presentVentViewController()
                        } else if gameState.wardrobeTapable {
                            print("Chest is tappable")
                            presentWardrobeViewController()
                        } else if gameState.cabinetTapable {
                            print("Chest is tappable")
                            presentCabinetViewController()
                        } else if gameState.safeTapable {
                            print("Chest is tappable")
                            presentCombLockViewController()
                        } else if gameState.picFrameTapable {
                            print("Chest is tappable")
                            presentPictureHintViewController()
                        } else {
                            print("No actionable state detected")
                        }
                    } else {
                        print("gameState is nil")
                    }
                }
        
        cameraNode.position = hero.position
//        
//        guard let heroNode = heroNode else { return }
//        let warningDistanceThreshold: CGFloat = 10.0
//        
//        var closestFurnitureNode: SKNode?
//        var minDistance: CGFloat = .greatestFiniteMagnitude
//        
//        self.enumerateChildNodes(withName: "furniture") { node, _ in
//            let distance = hypot(heroNode.position.x - node.position.x, heroNode.position.y - node.position.y)
//            if distance < minDistance {
//                minDistance = distance
//                closestFurnitureNode = node
//            }
//        }
//        
//        if let closestFurnitureNode = closestFurnitureNode, minDistance < warningDistanceThreshold {
//            warningSign.position = CGPoint(x: closestFurnitureNode.position.x, y: closestFurnitureNode.position.y + 50) // Adjust position as needed
//            warningSign.isHidden = false
//        } else {
//            warningSign.isHidden = true
//        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        contactManager.handleContactBegin(contactA: contact.bodyA.node?.name, contactB: contact.bodyB.node?.name)
    }
    
    public func didEnd(_ contact: SKPhysicsContact) {
        contactManager.handleContactEnd(contactA: contact.bodyA.node?.name, contactB: contact.bodyB.node?.name)
    }
    
    private func showActionSign(){
        
    }
    
    private func presentShadowViewController() {
        let shadowViewController = ShadowViewController()
        shadowViewController.modalPresentationStyle = .fullScreen
        viewController()?.present(shadowViewController, animated: true, completion: nil)
    }

    private func presentDrawerViewController() {
        let drawerViewController = DrawerViewController()
        drawerViewController.modalPresentationStyle = .fullScreen
        viewController()?.present(drawerViewController, animated: true, completion: nil)
    }

    private func presentSafeViewController() {
        let safeViewController = SafeViewController()
        safeViewController.modalPresentationStyle = .fullScreen
        viewController()?.present(safeViewController, animated: true, completion: nil)
    }

    private func presentVentViewController() {
        let ventViewController = VentViewController()
        ventViewController.modalPresentationStyle = .fullScreen
        viewController()?.present(ventViewController, animated: true, completion: nil)
    }

    private func presentWardrobeViewController() {
        let shakeView = ShakeView()
        let hostingController = UIHostingController(rootView: shakeView)
        hostingController.modalPresentationStyle = .fullScreen
        viewController()?.present(hostingController, animated: true, completion: nil)
    }

    private func presentCabinetViewController() {
        let cabinetView = FileCabinetView()
        let hostingController = UIHostingController(rootView: cabinetView)
        hostingController.modalPresentationStyle = .fullScreen
        viewController()?.present(hostingController, animated: true, completion: nil)
    }

    private func presentCombLockViewController() {
        let lockView = CombinationLockView()
        let hostingController = UIHostingController(rootView: lockView)
        hostingController.modalPresentationStyle = .fullScreen
        viewController()?.present(hostingController, animated: true, completion: nil)
    }

    private func presentPictureHintViewController() {
        let pictureView = AllAxisView()
        let hostingController = UIHostingController(rootView: pictureView)
        hostingController.modalPresentationStyle = .fullScreen
        viewController()?.present(hostingController, animated: true, completion: nil)
    }
}

extension SKScene {
    func viewController() -> UIViewController? {
        var responder: UIResponder? = self.view
        while responder != nil {
            responder = responder!.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


