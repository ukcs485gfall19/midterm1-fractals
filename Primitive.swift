//
//  Primitive.swift
//  MidtermFractalAppMacOS
//
//  Created by  on 10/6/19.
//  Copyright © 2019 Team Name. All rights reserved.
//

import MetalKit

class Primitive {
    
    //  makeCube
    //makes a cube using Metal
    class func makeCube(device: MTLDevice, size: Float) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mesh = MDLMesh(boxWithExtent: [size, size, size], segments: [1, 1, 1], inwardNormals: false, geometryType: .lines, allocator: allocator)
        return mesh
        
    }
}
