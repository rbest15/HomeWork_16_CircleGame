import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var heroInAir = false
    
    let backgroundNodeTexture = SKTexture(imageNamed: "Background")
    var backgroundSpriteNode = SKSpriteNode()
    let backgroundNode = SKNode()
    
    let heroNodeTexture = SKTexture(imageNamed: "Warrior_Run_1")
    var heroSpriteNode = SKSpriteNode()
    let heroNode = SKNode()
    
    var groundSpriteNode = SKSpriteNode()
    let groundNode = SKNode()
    
    var wallSpriteNode = SKSpriteNode()
    let wallNode = SKNode()
    
    var secondWallSpriteNode = SKSpriteNode()
    let secondWallNode = SKNode()
    
    
    let heroRunTextureArray : [SKTexture] = [SKTexture(imageNamed: "Warrior_Run_1"),
                                             SKTexture(imageNamed: "Warrior_Run_2"),
                                             SKTexture(imageNamed: "Warrior_Run_3"),
                                             SKTexture(imageNamed: "Warrior_Run_4"),
                                             SKTexture(imageNamed: "Warrior_Run_5"),
                                             SKTexture(imageNamed: "Warrior_Run_6"),
                                             SKTexture(imageNamed: "Warrior_Run_7"),
                                             SKTexture(imageNamed: "Warrior_Run_8"),
    ]
    
    let heroJumpTextureArray : [SKTexture] = [SKTexture(imageNamed: "Warrior_Jump_1"),
                                             SKTexture(imageNamed: "Warrior_Jump_2"),
                                             SKTexture(imageNamed: "Warrior_Jump_3"),
                                             SKTexture(imageNamed: "Warrior_UptoFall_1"),
                                             SKTexture(imageNamed: "Warrior_UptoFall_2"),
                                             SKTexture(imageNamed: "Warrior_Fall_1"),
    ]
    
    var musicNode = SKAudioNode()
    
    var heroMask : UInt32 = 1
    var groundMask : UInt32 = 2
    var wallMask : UInt32 = 3
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: -3, dy: -10)
        initialSetUp()
    }
    
    func initialSetUp() {
        createBackground(node: backgroundNode, texture: backgroundNodeTexture, speed: 3)
        createHero()
        createGround()
        createWall()
        createAudio()
        addChild(backgroundNode)
        addChild(heroNode)
        addChild(groundNode)
        addChild(wallNode)
        addChild(secondWallNode)
        addChild(musicNode)
    }
    
    func createBackground(node: SKNode, texture: SKTexture, speed: TimeInterval) {
        let moveBackground = SKAction.moveBy(x: -texture.size().width, y: 0, duration: speed)
        let replaceBackground = SKAction.moveBy(x: texture.size().width, y: 0, duration: 0)
        let moveBackgroundInf = SKAction.repeatForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for i in 0..<3 {
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = CGPoint(x: size.width / 4 + texture.size().width * CGFloat(i), y: size.height / 2)
            sprite.size.height = self.frame.height
            sprite.zPosition = -1
            sprite.run(moveBackgroundInf)
            node.addChild(sprite)
        }
    }
    
    func createGround() {
        groundSpriteNode.position = CGPoint.zero
        groundSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: 60))
        groundSpriteNode.physicsBody?.isDynamic = false
        groundSpriteNode.physicsBody?.categoryBitMask = groundMask
        groundSpriteNode.zPosition = 1
        
        groundNode.addChild(groundSpriteNode)
    }
    
    func createWall() {
        wallSpriteNode.position = CGPoint.zero
        wallSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: size.height * 2))
        wallSpriteNode.physicsBody?.isDynamic = false
        wallSpriteNode.physicsBody?.categoryBitMask = wallMask
        wallSpriteNode.zPosition = 1
        
        secondWallSpriteNode.position = CGPoint(x: size.width, y: 0)
        secondWallSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: size.height * 2))
        secondWallSpriteNode.physicsBody?.isDynamic = false
        secondWallSpriteNode.physicsBody?.categoryBitMask = wallMask
        secondWallSpriteNode.zPosition = 1
        
        secondWallNode.addChild(secondWallSpriteNode)
        wallNode.addChild(wallSpriteNode)
    }
    
    func addHero(at position: CGPoint) {
        heroSpriteNode = SKSpriteNode(texture: heroNodeTexture)
        let heroRunAnimation = SKAction.animate(with: heroRunTextureArray, timePerFrame: 0.1)
        let heroRun = SKAction.repeatForever(heroRunAnimation)
        heroSpriteNode.run(heroRun)
        
        heroSpriteNode.position = position
        heroSpriteNode.zPosition = 1
        heroSpriteNode.setScale(1.5)
        
        heroSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: heroSpriteNode.size.width, height: heroSpriteNode.size.height))
        heroSpriteNode.physicsBody?.categoryBitMask = heroMask
        heroSpriteNode.physicsBody?.contactTestBitMask = groundMask
        heroSpriteNode.physicsBody?.collisionBitMask = groundMask
        
        heroSpriteNode.physicsBody?.isDynamic = true
        heroSpriteNode.physicsBody?.allowsRotation = false
        
        heroNode.addChild(heroSpriteNode)
    }
    
    func createHero() {
        addHero(at: CGPoint(x: 0 + 100, y: size.height / 2))
    }
    
    func createAudio() {
        guard let musicURL = Bundle.main.url(forResource: "makai-symphony-dragon-slayer", withExtension: "mp3") else {
            fatalError()
        }
        musicNode = SKAudioNode(url: musicURL)
        musicNode.autoplayLooped = true
        musicNode.run(SKAction.play())
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            heroInAir = false
        }
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !heroInAir {
            heroJump()
        }
    }
    
    func heroJump() {
        heroInAir = true
        let jumpAnimation = SKAction.animate(with: heroJumpTextureArray, timePerFrame: 0.1)
        heroSpriteNode.run(jumpAnimation)
        heroSpriteNode.physicsBody?.velocity = CGVector.zero
        heroSpriteNode.physicsBody?.applyImpulse(CGVector(dx: 95, dy: 150))
    }
}
