//
//  Renderer.swift
//  MidtermFractalAppMacOS
//
//  Created by  on 10/6/19.
//  Copyright © 2019 Team Name. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    
    //set a timer to move object
    var timer: Float = 0
    
    //initiate GPU, command Queue, mesh, buffer (holds data), and pipelines
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    init(metalView: MTKView) {
        
        //search for GPU and command queue, and checking there's only one of each
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("GPU not available")
        }
        metalView.device = device
        Renderer.commandQueue = device.makeCommandQueue()!
        
        //initialize mesh
        
        let mdlMesh = Primitive.makeCube(device: device, size: 1)
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //initialize buffer
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        //initialize MTLLibrary
        
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        
        //initialize pipeline
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        do {
          pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
          fatalError(error.localizedDescription)
        }

        
        super.init()
        
        //set the background color to a white color
        
        metalView.clearColor = MTLClearColor(red:1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        metalView.delegate = self
    }
}

extension Renderer: MTKViewDelegate {
    
    //used to adjust coordinates of rendering
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    //creates the drawing
    
    func draw(in view: MTKView) {
        guard let descriptor = view.currentRenderPassDescriptor,
            let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
            else {
                return
        }
        
        //drawing code
        
        //move object up and down
        
        timer += 0.05
        var currentTime = sin(timer)
        
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 1)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        for submesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(type: .lineStrip,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        }
        
        //finish drawing, end encoding
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        
        //commit verifies GPU and data are correct
        
        commandBuffer.commit()
    }
}
