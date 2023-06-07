//
//  GameScene.swift
//  Solo MIssion
//
//  Created by MacBookMBA17 on 15/05/23.
//

import SpriteKit
import GameplayKit
// prueba del funcionamiento de git hub segunda pruebsa

class GameScene: SKScene, SKPhysicsContactDelegate{
    var gameScore = 0
    let scorelabel = SKLabelNode(fontNamed: "The Bold Font")
    var levelNumbre = 0
    
    let player = SKSpriteNode(imageNamed:"playerShip" /*"lovepik-space-shuttle-png-image_401191077_wh860 Background Removed"  */)
    
    let bulletSound = SKAction.playSoundFileNamed("SnapSave.io - Sonido de pistola laser (128 kbps)", waitForCompletion: false)
    let explosionsound = SKAction.playSoundFileNamed("X2Download.app - Explosion (juego arcade) - Efecto de sonido [Para descargar] (128 kbps)", waitForCompletion: false)
      
    
    struct PhysicsCategories
    {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
    }
    
    
    func random()->CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max : CGFloat)->CGFloat
    {
        return random() * (max-min) + min
    }
    
    let gameArea : CGRect
    
    override init(size : CGSize)
    {
        let maxAspectRatio : CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0 , width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Funcion para mostrar el background y la nave
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed:/*"background"*/ "HD-wallpaper-starry-sky-stars-space-dark-darkness")
        
        background.size =  self.size
        background.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        background.zPosition = 0
        view.showsPhysics = true
        self.addChild(background)
        
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/5)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        //player.physicsBody!.isDynamic = true// linea de prueba
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
    
        self.addChild(player)
        
        scorelabel.text =  "Score: 0"
        scorelabel.fontSize = 70
        scorelabel.fontColor = SKColor.white
        scorelabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scorelabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.9)
        scorelabel.zPosition = 100
        self.addChild(scorelabel)
        
        
        
        StarNewLevel()
    }
    
    func addScore()
    {
        gameScore += 1
        scorelabel.text = "Score \(gameScore)"
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        self.physicsWorld.contactDelegate = self
    
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else
        {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
      /*
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy{ //remove the final condition from here
          
   //The following bit has changed

               if body2.node != nil{
                   if body2.node!.position.y > self.size.height{
                       return //if the enemy is off the top of the screen, 'return'. This will stop running this code here, therefore doing nothing unless we hit the enemy when it's on the screen. As we are already checking that body2.node isn't nothing, we can safely unwrap (with '!)' this here.
                   }
                   /*else{
                   spawnExplosion(spawnPosition: body2.node!.position)
                   }*/
               }

   //changes end here
       */
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
                  
                  
                  if body1.node != nil{
                 spawnExplosion(spawnPosition: body1.node!.position)
                  }
                  
                  
                  if body2.node != nil{
                 spawnExplosion(spawnPosition: body2.node!.position)
                  }
                  
                  
                  body1.node?.removeFromParent()
                  body2.node?.removeFromParent()
              }
              
              if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height{
                  
                  addScore()
                  if body2.node != nil{
                  spawnExplosion(spawnPosition: body2.node!.position)
                  }
                  
                  body1.node?.removeFromParent()
                  body2.node?.removeFromParent()
               
           }
    }
    
    
    func spawnExplosion(spawnPosition: CGPoint){
          
          let explosion = SKSpriteNode (imageNamed:"explosion")
          explosion.position = spawnPosition
          explosion.zPosition = 3
          explosion.setScale(0)
          self.addChild(explosion)
          
          let scaleIn = SKAction.scale(to: 1, duration: 0.1)
          let fadeOut = SKAction.fadeOut(withDuration: 0.1)
          let delete = SKAction.removeFromParent()
          
          let explosionSequence = SKAction.sequence([explosionsound,scaleIn,fadeOut,delete])
          
          explosion.run(explosionSequence)
      }
    
    //func star new level
    func StarNewLevel()
    {
        levelNumbre += 1
        let spawn = SKAction.run(SpawnEnemy)
        let waitToSpaw = SKAction.wait(forDuration: 1)
        let spawSequence = SKAction.sequence([waitToSpaw,spawn])
        let spawnForever = SKAction.repeatForever(spawSequence)
        self.run(spawnForever, withKey: "")
    }
    
    
    //funcon para disparar
    func FireBullet()
    {
        let bullet = SKSpriteNode(imageNamed: "rayo" /*"playerShip"*/)
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSecuence = SKAction.sequence([bulletSound,moveBullet, deleteBullet])
        bullet.run(bulletSecuence)
    }
    
    func SpawnEnemy()
    {
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let starPoint = CGPoint(x:randomXStart,y:self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd,y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "meteorito")
        enemy.setScale(1)
        enemy.position = starPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySecuence = SKAction.sequence([moveEnemy,deleteEnemy])
        enemy.run(enemySecuence)
        
        let dx = endPoint.x - starPoint.x
        let dy = endPoint.y - starPoint.y
        let amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        FireBullet()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches
        {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            player.position.x += amountDragged
            
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2
            {
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
            }
            
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/2
            {
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
            }
        }
    }
    
}

