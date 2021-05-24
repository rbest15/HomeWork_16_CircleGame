import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let label = SKLabelNode(text: "GameOver")
    let scoreLabel = SKLabelNode(text: "Score:")
    var score : Int?
    var transitionDuration : TimeInterval?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        guard let score = score else {
            fatalError()
        }
        scoreLabel.text = "Score: \(score)"
        
        initialSetUp()
    }
    
    func initialSetUp() {
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        
        addChild(label)
        addChild(scoreLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let scene = GameScene(size: size)
        let transition = SKTransition.doorsCloseHorizontal(withDuration: transitionDuration ?? 0.5)

        view?.presentScene(scene, transition: transition)
    }
}
