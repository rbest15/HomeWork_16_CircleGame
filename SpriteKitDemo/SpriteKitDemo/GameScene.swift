import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = SKLabelNode(text: "Player")
    let enemy = SKLabelNode(text: "Enemy")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.fontColor = .green
        enemy.fontColor = .red
        scene?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        addChild(player)
        addChild(enemy)
        
        moveEnemy()
    }
    
    override func didEvaluateActions() {
        super.didEvaluateActions()
        if enemy.frame.intersects(player.frame) {
            let scene = GameOverScene(size: size)
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(scene, transition: transition)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        move(node: player, to: touches.first!.location(in: self), speed: 120)
    }
    
    func move(node: SKNode, to: CGPoint, speed: CGFloat, completion: (() -> Void)? = nil) {
        let x = node.position.x
        let y = node.position.y
        let distance = sqrt((x - to.x) * (x - to.x) + (y - to.y) * (y - to.y))
        let duration = TimeInterval(distance / speed)
        let move = SKAction.move(to: to, duration: duration)
        node.run(move, completion: completion ?? { })
    }
    
    func moveEnemy() {
        move(node: enemy, to: player.position, speed: 80) { [self] in
            moveEnemy()
        }
    }
}
