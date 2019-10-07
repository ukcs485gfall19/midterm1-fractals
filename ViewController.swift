//
//  ViewController.swift
//  MidtermFractalAppMacOS
//
//  Created by  on 10/6/19.
//  Copyright © 2019 Team Name. All rights reserved.
//

import MetalKit


//set up renderer in viewController
var renderer: Renderer?

class ViewController: NSViewController {

    override func viewDidLoad() {
        //set up metal
        guard let metalView = view as? MTKView else {
            fatalError("metal view not set up in storyboard")
        }
        super.viewDidLoad()

        //initiate rendering
        renderer = Renderer(metalView: metalView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

