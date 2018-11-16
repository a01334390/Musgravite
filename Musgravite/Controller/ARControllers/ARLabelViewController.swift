//
//  ARLabelViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ARLabelViewController: UIViewController, ARSCNViewDelegate {
    private var hitTestResult: ARHitTestResult!
    private var resnetModel = Resnet50()
    private var visionRequests = [VNRequest]()
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapEjecutado(_ sender: UITapGestureRecognizer) {
        let vista = sender.view as! ARSCNView
        let ubicacionToque = self.sceneView.center
        guard let currentFrame = vista.session.currentFrame else {return}
        let hitTestResults = vista.hitTest(ubicacionToque, types: .featurePoint)
        if (hitTestResults .isEmpty){
            return}
        guard var hitTestResult = hitTestResults.first else{
            return
        }
        let imagenPixeles = currentFrame.capturedImage
        self.hitTestResult = hitTestResult
        performVisionRequest(pixelBuffer: imagenPixeles)
    }
    
    private func performVisionRequest(pixelBuffer: CVPixelBuffer){
        //inicializar el modelo de ML al modelo usado, en este caso resnet
        let visionModel = try! VNCoreMLModel(for: resnetModel.model)
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            
            if error != nil {
                //hubo un error
                return}
            guard let observations = request.results else {
                //no hubo resultados por parte del modelo
                return
                
            }
            //obtener el mejor resultado
            let observation = observations.first as! VNClassificationObservation
            
            print("Nombre \(observation.identifier) confianza \(observation.confidence)")
            self.desplegarTexto(entrada: observation.identifier)
            
        }
        //la imagen que se pasará al modelo sera recortada para quedarse con el centro
        request.imageCropAndScaleOption = .centerCrop
        self.visionRequests = [request]
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])
        DispatchQueue.global().async {
            try! imageRequestHandler.perform(self.visionRequests)
            
        }
        
    }
    
    private func desplegarTexto(entrada: String){
        
        let letrero = SCNText(string: entrada, extrusionDepth: 0)
        letrero.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        letrero.firstMaterial?.diffuse.contents = UIColor.blue
        letrero.firstMaterial?.specular.contents = UIColor.white
        letrero.firstMaterial?.isDoubleSided = true
        letrero.font = UIFont(name: "Futura", size: 0.20)
        let nodo = SCNNode(geometry: letrero)
        nodo.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y-0.2,self.hitTestResult.worldTransform.columns.3.z )
        nodo.scale = SCNVector3Make(0.2, 0.2, 0.2)
        self.sceneView.scene.rootNode.addChildNode(nodo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
