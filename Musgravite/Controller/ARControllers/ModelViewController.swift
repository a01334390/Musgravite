//
//  ModelViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import ARKit
import SwiftMessages

class ModelViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    var diceNode:SCNNode?
    var modelURL:URL?
    var currentAngleY:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.info)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        let iconText = ["🔍"].sm_random()!
        view.configureContent(title: "Busca un plano", body: "Par ver un modelo, busca un plano", iconText: iconText)
        
        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .statusBar)
        config.duration = .forever
        
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)
    }
    
    /* Scale a model by pinching */
    @IBAction func modelScale(_ sender: UIPinchGestureRecognizer) {
        diceNode!.scale = SCNVector3(sender.scale, sender.scale, sender.scale)
    }
    
    /* Delete a model when hard press */
    @IBAction func deleteModel2(_ sender: Any) {
        diceNode?.removeFromParentNode()
        diceNode = nil
    }
    
    /* Rotate the model with Pan Gesture */
    @IBAction func rotateModel(_ sender: UIPanGestureRecognizer) {
        guard let nodeToRotate = diceNode else {return}
        let translation = sender.translation(in: sender.view!)
        var newAngleY = (Float)(translation.x) * (Float)(Double.pi)/180.0
        newAngleY += currentAngleY
        nodeToRotate.eulerAngles.y = newAngleY
        if (sender.state == .ended) {currentAngleY = newAngleY}
        print(nodeToRotate.eulerAngles)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    /* When a touch begins, just press it */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if diceNode == nil {
            if let touch = touches.first {
                let touchLocation = touch.location(in: sceneView)
                let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
                
                if let hitResult = results.first {
                    // Create a new scene
                    do{
                        let diceScene = try SCNScene(url: modelURL!,options: [.overrideAssetURLs: true])
                        diceNode = diceScene.rootNode.childNode(withName: "Pug", recursively: true)
                        diceNode!.position = SCNVector3(
                            x: hitResult.worldTransform.columns.3.x,
                            y: hitResult.worldTransform.columns.3.y,
                            z: hitResult.worldTransform.columns.3.z
                        )
                        sceneView.scene.rootNode.addChildNode(diceNode!)
                    }catch{
                        print("ERROR loading scene")
                    }
                }
            }
        }
    }
    
    
    /* Render the plane */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            SwiftMessages.hide()
            // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
            // files in the main bundle first, so you can easily copy them into your project and make changes.
            let view = MessageView.viewFromNib(layout: .cardView)
            
            // Theme message elements with the warning style.
            view.configureTheme(.info)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            // Set message title, body, and icon. Here, we're overriding the default warning
            // image with an emoji character.
            let iconText = ["🙌"].sm_random()!
            view.configureContent(title: "Plano encontrado", body: "Dale un tap a la pantalla para ver el modelo", iconText: iconText)
            
            // Increase the external margin around the card. In general, the effect of this setting
            // depends on how the given layout is constrained to the layout margins.
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
            // Reduce the corner radius (applicable to layouts featuring rounded corners).
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: .statusBar)
            
            
            // Show the message.
            SwiftMessages.show(config: config, view: view)
            
            /* Stop showing? */
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "grid")
            plane.materials = [gridMaterial]
            let planeNode = SCNNode()
            planeNode.geometry = plane
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            node.addChildNode(planeNode)
        } else {
            return
        }
        //guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.pause()
        SwiftMessages.hide()
    }
}
