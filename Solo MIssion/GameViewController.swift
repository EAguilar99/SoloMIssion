//
//  GameViewController.swift
//  Solo MIssion
//
//  Created by MacBookMBA17 on 15/05/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        ///prueba de github sefgunda prueba jejej
        
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        //if let scene = GKScene(fileNamed: "GameScene") {
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
            
            let skView = self .view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        //}
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
