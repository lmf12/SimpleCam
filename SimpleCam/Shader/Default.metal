//
//  Default.metal
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/8.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct {
    float4 position;
    float2 texCoords;
} VertexIn;

typedef struct {
    float4 position [[position]];
    float2 texCoords;
} VertexOut;


vertex VertexOut defaultVertexShader(const device VertexIn *vertexArray [[buffer(0)]],
                              unsigned int vertexID [[vertex_id]]) {
    VertexOut vertexOut;
    vertexOut.position = vertexArray[vertexID].position;
    vertexOut.texCoords = vertexArray[vertexID].texCoords;
    return vertexOut;
}

fragment float4 defaultFragmentShader(VertexOut vertexIn [[stage_in]],
                               texture2d <float, access::sample> inputImage [[texture(0)]]) {
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    float4 color = inputImage.sample(textureSampler, vertexIn.texCoords);
    return color;
}
