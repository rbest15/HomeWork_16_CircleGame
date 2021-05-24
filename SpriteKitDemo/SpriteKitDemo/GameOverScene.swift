import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let gameover = SKLabelNode(text: "Game over")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        gameover.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scene?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        addChild(gameover)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let scene = GameScene(size: size)
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        
        view?.presentScene(scene, transition: transition)
    }
}
