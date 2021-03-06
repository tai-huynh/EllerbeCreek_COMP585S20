//
//  SightingView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import ARKit

class SightingView: NibBasedView {
    
    public weak var delegate: SightingViewControllerDelegate?
    
    private var sighting: Sighting!
    
    private var isNodePresent: Bool = false
    private var arAnimal: ARAnimal!
    private var nodeModel: SCNNode = SCNNode()
    
    @IBOutlet var dismissButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setImage(UIImage(named: "Close"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 8.0
            }
        }
    }
    
    
    @IBOutlet var sceneView: ARSCNView! {
        willSet {
            if let sceneView = newValue {
                sceneView.delegate = self
                sceneView.antialiasingMode = .multisampling4X
                sceneView.scene = SCNScene()
            }
        }
    }
    @IBOutlet var instructionsLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.textAlignment = .center
                label.numberOfLines = 2
                label.textColor = Colors.white
                label.font = Fonts.semibold.withSize(28.0)

                label.layer.shadowColor = Colors.black.cgColor
                label.layer.shadowRadius = 6.0
                label.layer.shadowOpacity = 1.0
                label.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                label.layer.masksToBounds = false
                
                label.text = "Tap the animal to \n observe it"
            }
        }
    }
    
    required init(sighting: Sighting) {
        self.sighting = sighting
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)        
        commonInit()
    }
    
    private func commonInit() {
        arAnimal = ARAnimals.animals.filter { $0.type == sighting.animal.type! }.first
        let modelScene = SCNScene(named: arAnimal.assetPath)!
        for child in modelScene.rootNode.childNodes {
            nodeModel.name = arAnimal.name
            nodeModel.addChildNode(child as SCNNode)
        }
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == arAnimal.name {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    
    @IBAction func dismissButtonAction() {
        sceneView.session.pause()
        
        guard let delegate = delegate else { return }
        delegate.showGameMap()
    }
    
}

extension SightingView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: sceneView)

        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult] = sceneView.hitTest(location, options: hitTestOptions)
        
        if let hit = hitResults.first {
          if let node = getParent(hit.node) {
            node.removeFromParentNode()
            
            guard let delegate = delegate else { return }
            sceneView.session.pause()
            
            SessionManager.shared.addSighting(sighting)
            delegate.showSightingDetail(for: sighting)
            return
          }
        }
    }
    
}

extension SightingView: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if !isNodePresent {
            isNodePresent = true

            let modelClone = self.nodeModel.clone()
            modelClone.position = SCNVector3(0.0, -1.0, -1.0)
            modelClone.scale = SCNVector3(0.075, 0.075, 0.075)

            sceneView.scene.rootNode.addChildNode(modelClone)
        }
    }
    
}
