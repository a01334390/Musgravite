//
//  VideoViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import ARKit
import SwiftMessages

class VideoViewController: UIViewController, ARSCNViewDelegate {
    var videoURL:URL?
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
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
        view.configureContent(title: "Busca un QR", body: "Para ver un video, busca el QR del laboratorio", iconText: iconText)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        //Images to track
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "VideoIdentifiers", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
        SwiftMessages.hide()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            /* Retrieve the video element */
            let videoNode = SKVideoNode(url: videoURL!)
            videoNode.play()
           /* Add the video to the scene when image is retrieved */
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            videoNode.position = CGPoint(x: videoScene.size.width / 2 ,y: videoScene.size.height / 2)
            videoNode.yScale = -1.0
            videoScene.addChild(videoNode) //Ready to display in 2D
            /* Add the video scene to the ARSCN */
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
        }
        return node
    }
}
