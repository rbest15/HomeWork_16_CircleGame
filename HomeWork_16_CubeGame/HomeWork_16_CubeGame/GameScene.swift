import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var heroInAir = false
    var gameIsPaused = false {
        didSet {
            if gameIsPaused == true {
                children.forEach { node in
                    node.removeAllActions()
                    node.children.forEach { node in
                        node.removeAllActions()
                    }
                }
                enemyNodeArray.forEach { node in
                    node.physicsBody?.affectedByGravity = false
                }
                musicNode.run(SKAction.stop())
                timer.invalidate()
            }
        }
    }
    
    var timer = Timer()

    let heroNodeTexture = SKTexture(imageNamed: "Warrior_Run_1")
    var heroSpriteNode = SKSpriteNode()
    let heroNode = SKNode()
    
    var backGroundNodeArray = [SKNode]()
    var enemyNodeArray = [SKNode]()
    
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

    let bgLayerTextures : [(SKTexture, CGFloat)]  = [(SKTexture(imageNamed: "Layer_0000_9"), 3),
                                                     (SKTexture(imageNamed: "Layer_0001_8"), 3),
                                                     (SKTexture(imageNamed: "Layer_0002_7"), 3),
                                                     (SKTexture(imageNamed: "Layer_0003_6"), 3),
                                                     (SKTexture(imageNamed: "Layer_0004_Lights"), 3),
                                                     (SKTexture(imageNamed: "Layer_0005_5"), 4),
                                                     (SKTexture(imageNamed: "Layer_0006_4"), 4),
                                                     (SKTexture(imageNamed: "Layer_0007_Lights"), 4),
                                                     (SKTexture(imageNamed: "Layer_0008_3"), 5),
                                                     (SKTexture(imageNamed: "Layer_0009_2"), 5),
                                                     (SKTexture(imageNamed: "Layer_0010_1"), 5)
    ]
    
    let enenyTexture: [SKTexture] = [SKTexture(imageNamed: "fly01"),
                                     SKTexture(imageNamed: "fly02"),
                                     SKTexture(imageNamed: "fly03"),
                                     SKTexture(imageNamed: "fly04"),
                                     SKTexture(imageNamed: "fly05"),
                                     SKTexture(imageNamed: "fly06"),
                                     SKTexture(imageNamed: "fly07")
    ]
    
    var musicNode = SKAudioNode()
    
    var heroMask : UInt32 = 1
    var groundMask : UInt32 = 2
    var wallMask : UInt32 = 3
    var enemyMask : UInt32 = 4
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initialSetUp()
    }
    
    func initialSetUp() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: -3, dy: -10)
        
        addBackground()
        createHero()
        createGround()
        createWall()
        createAudio()
        startSpawn()
        addChild(heroNode)
        addChild(groundNode)
        addChild(wallNode)
        addChild(secondWallNode)
        addChild(musicNode)
    }
    
    func addBackgroundLayer(texture: SKTexture, speed: TimeInterval, zPosOffset: CGFloat) {
        let node = SKNode()
        let moveBackground = SKAction.moveBy(x: -texture.size().width, y: 0, duration: speed)
        let replaceBackground = SKAction.moveBy(x: texture.size().width, y: 0, duration: 0)
        let moveBackgroundInf = SKAction.repeatForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for i in 0..<3 {
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = CGPoint(x: size.width / 4 + texture.size().width * CGFloat(i), y: size.height / 2)
            sprite.size.height = self.frame.height
            sprite.zPosition = -zPosOffset
            sprite.run(moveBackgroundInf)
            node.addChild(sprite)
        }
        backGroundNodeArray.append(node)
        addChild(node)
    }
    
    fileprivate func addBackground() {
        var index = 0
        for text in bgLayerTextures {
            addBackgroundLayer(texture: text.0, speed: TimeInterval(text.1), zPosOffset: CGFloat(index))
            index += 1
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
        
        secondWallSpriteNode.position = CGPoint(x: size.width + 60, y: 0)
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
    
    func createEnemy(height: CGFloat) {
        let enemyNode = SKNode()
        let enemySpriteNode = SKSpriteNode(texture: enenyTexture[0])
        let enemyAnimation = SKAction.animate(with: enenyTexture, timePerFrame: 0.1)
        let enemyAnimationRepeat = SKAction.repeatForever(enemyAnimation)
        enemySpriteNode.run(enemyAnimationRepeat)
        
        enemySpriteNode.position = CGPoint(x: size.width, y: height)
        enemySpriteNode.zPosition = 1
        
        enemySpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enenyTexture[0].size().width, height: enenyTexture[0].size().height))
        enemySpriteNode.physicsBody?.categoryBitMask = enemyMask
        enemySpriteNode.physicsBody?.contactTestBitMask = heroMask
        enemySpriteNode.physicsBody?.collisionBitMask = groundMask
        
        enemySpriteNode.physicsBody?.isDynamic = true
        enemySpriteNode.physicsBody?.affectedByGravity = false
        
        let move = SKAction.applyImpulse(CGVector(dx: -100, dy: 0), duration: 10)
        enemySpriteNode.run(move)
        
        enemyNodeArray.append(enemyNode)
        enemyNode.addChild(enemySpriteNode)
        addChild(enemyNode)
    }
    
    func startSpawn() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.createEnemy(height: CGFloat.random(in: 0...self.size.height - 50))
        }
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            heroInAir = false
            if gameIsPaused {
                physicsWorld.gravity = CGVector(dx: 0, dy: -10)
            }
        }
        
        if contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 1 || contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4 {
            gameIsPaused = true
            physicsWorld.gravity = CGVector(dx: 0, dy: -10)
        }
        
        if contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 3 || contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 4 {
            if contact.bodyA.categoryBitMask == 4 {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            
        }
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !heroInAir {
            if !gameIsPaused {
                heroJump()
            }
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
