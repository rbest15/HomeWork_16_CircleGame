import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: self.view.frame.size)
        let skView = view as! SKView
        
        skView.presentScene(scene)
        
    }
}
