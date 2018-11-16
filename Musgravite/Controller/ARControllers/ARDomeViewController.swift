//
//  ARDomeViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARDomeViewController: UIViewController, ARSCNViewDelegate {
    var panonoImageURL:URL?
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    @IBOutlet weak var planeDetected: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mostrar el origen y los puntos detectados
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        //indicar la detección del plano
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        //administrador de gestos para identificar el tap sobre el plano horizontal
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.sceneView.addGestureRecognizer(tap)
        planeDetected.isHidden = true
    }
    
    @objc func tapHandler(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        //obtener los resultados del tap sobre el plano horizontal
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty{
            //cargar la escena
            self.addPortal(hitTestResult: hitTestResult.first!)
        }
        else{
            // no hubo resultado
        }
    }
    
    private func load(fileURL: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    //cargar el portal
    func addPortal(hitTestResult:ARHitTestResult)
    {
        let portalScene = SCNScene(named:"art.scnassets/Portal.scn")
        let portalNode = portalScene?.rootNode.childNode(withName: "Portal", recursively: false)
        portalNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        portalNode?.geometry?.firstMaterial?.transparency = 0.00001
        let sphericalNode = portalNode?.childNode(withName: "sphere", recursively: false)
        sphericalNode?.geometry?.firstMaterial?.diffuse.contents = load(fileURL: panonoImageURL!)
        //convertir las coordenadas del rayo del tap a coordenadas del mundo real
        let transform = hitTestResult.worldTransform
        let planeXposition = transform.columns.3.x
        let planeYposition = transform.columns.3.y
        let planeZposition = transform.columns.3.z
        portalNode?.position = SCNVector3(planeXposition,planeYposition,planeZposition)
        self.sceneView.scene.rootNode.addChildNode(portalNode!)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return} //se agrego un plano
        //ejecución asincrona en donde se modifica la etiqueta de plano detectado
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
            print("Plano detectado")
        }
        //espera 3 segundos antes de desaparecer
        DispatchQueue.main.asyncAfter(deadline: .now()+3){self.planeDetected.isHidden = true}
    }
}
