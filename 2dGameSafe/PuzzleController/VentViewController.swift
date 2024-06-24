import UIKit
import SpriteKit

public class VentViewController: UIViewController, SKPhysicsContactDelegate {
    
    private var scene: SKScene!
    private var sceneView = SKView()
    private var screenSize: CGSize!
    
    private var selectedNode: SKSpriteNode!
    private var boltRotations: [SKSpriteNode: Int] = [:]
    
    private var numberOfBoltsAffectedByGravity: Int = 0

    private var rotationTimer: Timer?
    
    private var isTapped = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenSize()
        setup()
//        addRotateGestureRecognizer()
        addLongPressGestureRecognizer()
        addTapGestureRecognizer()
    }
    
    private func setupScreenSize() {
        let screenBounds = UIScreen.main.bounds
        let screenWidth = max(screenBounds.width, screenBounds.height)
        let screenHeight = min(screenBounds.width, screenBounds.height)
        screenSize = CGSize(width: screenWidth, height: screenHeight)
        sceneView.frame = CGRect(origin: .zero, size: screenSize)
        view.addSubview(sceneView)
    }
    
    func setup() {
        scene = SKScene(size: screenSize)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .black
        
        scene.physicsWorld.contactDelegate = self
        let width = scene.size.width
        let height = scene.size.height
        
        let ventNode = SKSpriteNode(imageNamed: "Grill")
        ventNode.size = CGSize(width: 300, height: 300)
        ventNode.position = CGPoint(x: width / 2, y: height / 2)
        ventNode.zPosition = 0
        ventNode.physicsBody = SKPhysicsBody(rectangleOf: ventNode.size)
        ventNode.physicsBody?.affectedByGravity = false
        ventNode.physicsBody?.isDynamic = false
        ventNode.physicsBody?.categoryBitMask = bitMasks.vent.rawValue
        ventNode.name = "vent"
        scene.addChild(ventNode)
        
        let positions: [CGPoint] = [
            CGPoint(x: width / 2 + 130, y: height / 2 + 130),
            CGPoint(x: width / 2 - 130, y: height / 2 - 130),
            CGPoint(x: width / 2 - 130, y: height / 2 + 130),
            CGPoint(x: width / 2 + 130, y: height / 2 - 130)
        ]
        
        for position in positions {
            let boltNode = SKSpriteNode(imageNamed: "Screw")
            boltNode.size = CGSize(width: 20, height: 20)
            boltNode.position = position
            boltNode.zPosition = 2
            boltNode.physicsBody = SKPhysicsBody(circleOfRadius: boltNode.size.width)
            boltNode.physicsBody?.affectedByGravity = false
            boltNode.physicsBody?.isDynamic = false
            boltNode.physicsBody?.categoryBitMask = bitMasks.bolt.rawValue
            boltNode.name = "bolt"
            
            scene.addChild(boltNode)
            
            boltRotations[boltNode] = 0
        }
        
        let knifeNode = SKSpriteNode(imageNamed: "Background")
        knifeNode.size = CGSize(width: 300, height: 300)
        knifeNode.position = CGPoint(x: width / 2, y: height / 2)
        knifeNode.zPosition = -1
        knifeNode.name = "knife"
        scene.addChild(knifeNode)

        sceneView.presentScene(scene)
        addCloseButton()
    }
    
    private func addCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .red
        closeButton.layer.cornerRadius = 10
        closeButton.frame = CGRect(x: 20, y: 40, width: 40, height: 40)
        closeButton.addTarget(self, action: #selector(returnToGameViewController), for: .touchUpInside)
        
        view.addSubview(closeButton)
    }
    
    @objc private func returnToGameViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    private func addLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        sceneView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let scene = scene else { return }

        let location = gesture.location(in: sceneView)
        let sceneLocation = scene.convertPoint(fromView: location)

        switch gesture.state {
        case .began:
            if let node = scene.atPoint(sceneLocation) as? SKSpriteNode, node.name == "bolt" {
                selectedNode = node
                startRotationTimer()
            }
        case .ended, .cancelled:
            stopRotationTimer()
            selectedNode = nil
        default:
            break
        }
    }
    
    private func startRotationTimer() {
        rotationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(rotateBolt), userInfo: nil, repeats: true)
    }

    private func stopRotationTimer() {
        rotationTimer?.invalidate()
        rotationTimer = nil
    }

    @objc private func rotateBolt() {
        guard let node = selectedNode else { return }
        if node.physicsBody?.affectedByGravity == true {
            return
        }
        node.zRotation += CGFloat.pi / 16
        let currentRotations = (boltRotations[node] ?? 0) + 1
        boltRotations[node] = currentRotations
        
        if currentRotations >= 48 {
            print("nilai awal \(numberOfBoltsAffectedByGravity)")
            node.physicsBody?.affectedByGravity = true
            node.physicsBody?.isDynamic = true
            node.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
            numberOfBoltsAffectedByGravity += 1
            print("nilai akhir \(numberOfBoltsAffectedByGravity)")
            if numberOfBoltsAffectedByGravity >= 4 {
                makeVentAffectedByGravity()
            }
        }
    }
    
    private func makeVentAffectedByGravity() {
        guard let ventNode = scene.childNode(withName: "vent") else { return }
        ventNode.physicsBody?.affectedByGravity = true
        ventNode.physicsBody?.isDynamic = true
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let scene = scene else { return }
        let location = gesture.location(in: sceneView)
        let sceneLocation = scene.convertPoint(fromView: location)
        
        if let node = scene.atPoint(sceneLocation) as? SKSpriteNode, node.name == "knife" {
            if numberOfBoltsAffectedByGravity >= 4, isTapped == false {
                animateKnife(node)
                isTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.returnToGameViewController()
                }
                print("knife tapped")
            }
        }
    }
    
    private func animateKnife(_ knifeNode: SKSpriteNode) {
        let scaleAction = SKAction.scale(by: 2, duration: 1)
        let reverseAction = scaleAction.reversed()
        let sequence = SKAction.sequence([scaleAction, reverseAction])
        knifeNode.run(sequence)
    }
    
    private func addRotateGestureRecognizer() {
        let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
        sceneView.addGestureRecognizer(rotateGestureRecognizer)
    }
    
    @objc private func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let scene = scene else { return }
        
        let location = gesture.location(in: sceneView)
        let sceneLocation = scene.convertPoint(fromView: location)
        
        if gesture.state == .began {
            if let node = scene.atPoint(sceneLocation) as? SKSpriteNode, node.name == "bolt" {
                selectedNode = node
            }
        }
        
        if gesture.state == .changed {
            selectedNode?.zRotation -= gesture.rotation
            gesture.rotation = 0
        }
        
        if gesture.state == .ended {
            if let node = selectedNode, node.name == "bolt" {
                let currentRotations = boltRotations[node] ?? 0
                let totalRotations: Int
                
                if gesture.velocity > 0 {
                    totalRotations = currentRotations - 1
                } else {
                    totalRotations = currentRotations + 1
                }
                
                boltRotations[node] = totalRotations
                
                if totalRotations >= 2 {
                    node.physicsBody?.affectedByGravity = true
                } else if totalRotations < 2 {
                    node.physicsBody?.affectedByGravity = false
                }
            }
            selectedNode = nil
        }
    }
}
