//
//  P360ViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SceneKit
import CTPanoramaView
import SwiftMessages
import Vision
import ARKit

class P360ViewController: UIViewController {
    var panonoImage:UIImage?
    private var hitTestResult: ARHitTestResult!
    private var resnetModel = Resnet50()
    private var visionRequests = [VNRequest]()
    @IBOutlet weak var compassView: CTPieSliceView!
    @IBOutlet weak var pv: CTPanoramaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSphericalImage()
        pv.compass = compassView
    }
    
    @IBAction func panoramaTypeTapped() {
        if pv.panoramaType == .spherical {
            loadCylindricalImage()
        }
        else {
            loadSphericalImage()
        }
    }
    
    @IBAction func motionTypeTapped() {
        if pv.controlMethod == .touch {
            pv.controlMethod = .motion
        }
        else {
            pv.controlMethod = .touch
        }
    }
    
    func loadSphericalImage() {
        pv.image = panonoImage
    }
    
    func loadCylindricalImage() {
        pv.image = panonoImage
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    //ML stuff
    
    @IBAction func tapEjecutado(_ sender: UITapGestureRecognizer) {
        let vista = sender.view as! ARSCNView
        let ubicacionToque = self.pv.center
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
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.info)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        let iconText = ["👀"].sm_random()!
        view.configureContent(title: "Estas viendo", body: entrada, iconText: iconText)
        
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
