import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var player = SKShapeNode()
    var enemy = SKShapeNode()
    
    let playerRadius : CGFloat = 10
    
    var enemyRadius : CGFloat = 10
    var enemyScale : CGFloat = 1.0 {
        didSet {
            scoreIncrese += 1
        }
    }
    let enemyScaleStep : CGFloat = 0.1
    let enemyYPosOffset : CGFloat = 100
    
    let playerSpeed : CGFloat = 120
    var enemySpeed : CGFloat = 80
    
    var score : Int = 0
    var scoreIncrese : Int = 1
    let scoreLabel = SKLabelNode(text: "0")
    let scoreYPosOffset : CGFloat = 100
    
    let transitionDuration: TimeInterval = 0.5
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initialSetUp()
        startEnemyMoving()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        moveNode(player, to: touches.first!.location(in: self), speed: playerSpeed)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        moveNode(player, to: touches.first!.location(in: self), speed: playerSpeed)
    }
    
    func initialSetUp() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        player = SKShapeNode(circleOfRadius: playerRadius)
        enemy = SKShapeNode(circleOfRadius: enemyRadius)
        
        player.fillColor = #colorLiteral(red: 0.05683284253, green: 0.7200763822, blue: 0.9884522557, alpha: 1)
        enemy.fillColor = #colorLiteral(red: 1, green: 0.02140153199, blue: 0.004378358368, alpha: 1)
        
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        enemy.position = CGPoint(x: size.width / 2, y: enemyRadius + enemyYPosOffset)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - scoreYPosOffset)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        addChild(player)
        addChild(enemy)
        addChild(scoreLabel)
    }
    
    
    func moveNode(_ node: SKNode, to: CGPoint, speed: CGFloat, comletion: (() -> Void)? = nil) {
        let y = node.position.y
        let x = node.position.x
        let distance = sqrt((x - to.x) * (x - to.x) + (y - to.y) * (y - to.y))
        let duration = TimeInterval(distance / speed)
        node.run(SKAction.move(to: to, duration: duration))
    }
    
    func startEnemyMoving() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.moveNode(self.enemy, to: self.player.position, speed: self.enemySpeed)
            self.updateScore()
        }
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.enemyScale += self.enemyScaleStep
            self.enemy.setScale(self.enemyScale)
            self.enemy.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyRadius * self.enemyScale)
        }
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.enemySpeed += 10
        }
    }
    
    func updateScore() {
        score += scoreIncrese
        scoreLabel.text = String(score)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let scene = GameOverScene(size: size)
        let transition = SKTransition.doorsCloseVertical(withDuration: transitionDuration)
        scene.score = score
        scene.transitionDuration = transitionDuration
        view!.presentScene(scene, transition: transition)
    }
}

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let player    : UInt32 = 0b1
  static let enemy     : UInt32 = 0b10
}
