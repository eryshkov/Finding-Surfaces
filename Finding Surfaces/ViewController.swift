//
//  ViewController.swift
//  Finding Surfaces
//
//  Created by Evgeniy Ryshkov on 17.09.2018.
//  Copyright © 2018 Evgeniy Ryshkov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        //        print(#function, planeAnchor)
        
        let floor = createFloor(planeAnchor: planeAnchor)
        node.addChildNode(floor)
        createCube(to: node, width: 0.4)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let floor = node.childNodes.first,
            let geometry = floor.geometry as? SCNPlane
            else { return }
        geometry.width = CGFloat(planeAnchor.extent.x)
        geometry.height = CGFloat(planeAnchor.extent.z)
        
        floor.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        
        let geometry = SCNPlane(width: width, height: height)
        
        let node = SCNNode()
        node.geometry = geometry
        
        node.opacity = 0.25
        node.eulerAngles.x = -Float.pi / 2
        
        return node
    }
    
    func createCube(to node: SCNNode, width: CGFloat) {
        let newNode = SCNNode()
        
        let geometry = SCNBox(width: width, height: width, length: width, chamferRadius: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.green
        newNode.opacity = 0.4
        newNode.geometry = geometry
        newNode.position = SCNVector3(newNode.position.x,
                                      newNode.position.y + Float(width / 2),
                                      newNode.position.z)
        
        node.addChildNode(newNode)
    }
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
