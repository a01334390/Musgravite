//
//  VideoViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import ARKit

class VideoViewController: UIViewController, ARSCNViewDelegate {
    var videoURL:URL?
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
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
