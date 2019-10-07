//
//  Shaders.metal
//  MidtermFractalAppMacOS
//
//  Created by  on 10/6/19.
//  Copyright © 2019 Team Name. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//VertexIn connects the physical vertexes with the vertex descriptor in Renderer.swift

struct VertexIn {
    float4 position [[ attribute(0)]];
};

//vertex_main is a shader returning positions of all vertexes

vertex float4 vertex_main(const VertexIn vertexIn [[ stage_in ]], constant float &timer [[ buffer(1) ]]) {
    float4 position = vertexIn.position;
    position.y += timer;
    return position;
}

//make all fragments of the object red

fragment float4 fragment_main() {
    return float4(0, 0, 0, 0);
}
