import UIKit
import SpriteKit

public class SafeViewController: UIViewController, SKPhysicsContactDelegate {
    
    private var scene: SKScene!
    private var sceneView = SKView()
    private var screenSize: CGSize!
    
    var selectedNode: SKSpriteNode!
    var initialRotation: CGFloat = 0.0
    
    private var isTapped = false
    
    let password = [6, 5, 7]
    var enteredPassword: [Int] = []
    
    private var lastRotationDirection: RotationDirection = .none
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenSize()
        setup()
        addRotateGestureRecognizer()
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
        
        let safeNode = SKSpriteNode(imageNamed: "safeDoor")
        safeNode.size = CGSize(width: 300, height: 300)
        safeNode.position = CGPoint(x: width / 2, y: height / 2)
        safeNode.zPosition = 0
        safeNode.physicsBody = SKPhysicsBody(rectangleOf: safeNode.size)
        safeNode.physicsBody?.affectedByGravity = false
        safeNode.physicsBody?.isDynamic = false
        safeNode.physicsBody?.categoryBitMask = bitMasks.safe.rawValue
        safeNode.name = "safe"
        scene.addChild(safeNode)
        
        let lockNode = SKSpriteNode(imageNamed: "safeDial")
        lockNode.size = CGSize(width: 100, height: 100)
        lockNode.position = CGPoint(x: width / 2 + 80, y: height / 2)
        lockNode.zPosition = 1
        lockNode.physicsBody = SKPhysicsBody(circleOfRadius: lockNode.xScale)
        lockNode.physicsBody?.affectedByGravity = false
        lockNode.physicsBody?.isDynamic = false
        lockNode.physicsBody?.categoryBitMask = bitMasks.safe.rawValue
        lockNode.name = "lock"
        scene.addChild(lockNode)
        
        let indicatorNode = SKSpriteNode(imageNamed: "safeIndicator")
        indicatorNode.size = CGSize(width: 20, height: 20)
        indicatorNode.position = CGPoint(x: 80, y: 60)
        indicatorNode.zPosition = 0
        indicatorNode.name = "indicator"
        safeNode.addChild(indicatorNode)
        
        let handleNode = SKSpriteNode(imageNamed: "safeHandle")
        handleNode.size = CGSize(width: 100, height: 40)
        handleNode.position = CGPoint(x: -80, y: 0)
        handleNode.zPosition = 0
        handleNode.name = "handle"
        safeNode.addChild(handleNode)
        
        let documentNode = SKSpriteNode(imageNamed: "document")
        documentNode.size = CGSize(width: 200, height: 200)
        documentNode.position = CGPoint(x: width / 2, y: height / 2)
        documentNode.zPosition = -1
        documentNode.name = "document"
        scene.addChild(documentNode)
        
        let insideSafeNode = SKSpriteNode(imageNamed: "safeInside")
        insideSafeNode.size = CGSize(width: 300, height: 300)
        insideSafeNode.position = CGPoint(x: width / 2, y: height / 2)
        insideSafeNode.zPosition = -2
        scene.addChild(insideSafeNode)

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
    
    private func makeSafeOpen() {
        guard let safeNode = scene.childNode(withName: "safe"), let lockNode = scene.childNode(withName: "lock") else { return }
        let moveAction = SKAction.moveBy(x: 200, y: 0, duration: 1.0)
        safeNode.run(moveAction)
        lockNode.run(moveAction)
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let scene = scene else { return }
        let location = gesture.location(in: sceneView)
        let sceneLocation = scene.convertPoint(fromView: location)
        
        if let node = scene.atPoint(sceneLocation) as? SKSpriteNode, node.name == "document" {
            if isTapped == false {
                animateDocument(node)
                isTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.returnToGameViewController()
                }
            }
        }
    }

    private func animateDocument(_ documentNode: SKSpriteNode) {
        let scaleAction = SKAction.scale(by: 2, duration: 1)
        let reverseAction = scaleAction.reversed()
        let sequence = SKAction.sequence([scaleAction, reverseAction])
        documentNode.run(sequence)
    }
    
    private func addRotateGestureRecognizer() {
        let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
        sceneView.addGestureRecognizer(rotateGestureRecognizer)
    }
    
    @objc private func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let scene = scene, let lockNode = scene.childNode(withName: "lock") as? SKSpriteNode else { return }
        
        let rotation = gesture.rotation
        
        switch gesture.state {
            case .began:
                initialRotation = lockNode.zRotation
            case .changed:
                let currentRotationDirection: RotationDirection = rotation > 0 ? .clockwise : .counterclockwise
                if lastRotationDirection == .none || lastRotationDirection != currentRotationDirection {
                    lockNode.zRotation = initialRotation - rotation
                }
            case .ended, .cancelled:
                snapToNearestNumber(lockNode: lockNode, rotation: rotation)
            default:
                break
        }
    }
    
    private func snapToNearestNumber(lockNode: SKSpriteNode, rotation: CGFloat) {
        let segmentAngle = .pi / 5.0
        let normalizedRotation = lockNode.zRotation.truncatingRemainder(dividingBy: 2 * CGFloat.pi)
        var angleIndex = Int((normalizedRotation + CGFloat.pi) / segmentAngle)
        
        angleIndex = (angleIndex + 10) % 10
        
        let snappedRotation = CGFloat(angleIndex) * segmentAngle - CGFloat.pi
        
        let rotateAction = SKAction.rotate(toAngle: snappedRotation, duration: 0.2, shortestUnitArc: true)
        lockNode.run(rotateAction)
        
        print("Current number: \(angleIndex)")
        verifyPassword(at: angleIndex)
        
        lastRotationDirection = rotation > 0 ? .clockwise : .counterclockwise
    }
    
    private func verifyPassword(at index: Int) {
        guard enteredPassword.count < password.count else { return }
        if !enteredPassword.isEmpty && index == enteredPassword.last! {
            print("Ignoring repeated entry: \(index)")
            return
        }
        if index == password[enteredPassword.count] {
            enteredPassword.append(index)
            print("password skrg \(enteredPassword)")
            if enteredPassword.count == password.count {
                makeSafeOpen()
            }
        } else {
            print("password salah blog")
            enteredPassword.removeAll()
        }
    }
}
