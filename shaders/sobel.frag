#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 resolution;
uniform sampler2D image;

void main(){
    vec2 pos = FlutterFragCoord().xy / resolution;
    vec2 convolutionMatrix[9] = vec2[9](
        vec2(-1.0, -1.0),
        vec2(0.0, -1.0),
        vec2(1.0, -1.0),
        vec2(-1.0, 0.0),
        vec2(0.0, 0.0),
        vec2(1.0, 0.0),
        vec2(-1.0, 1.0),
        vec2(0.0, 1.0),
        vec2(1.0, 1.0)
    );
    vec4 n[9];
    for(int i = 0; i < 9; i++){
        vec4 color = texture(image, (convolutionMatrix[i] / resolution) + pos);
        float luminance = color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
        n[i] = vec4(luminance, luminance, luminance, 1.0);
    }
    vec4 sobel_edge_h = n[2] + (n[5] * 2) + n[8] - (n[0] + (n[3] * 2) + n[6]);
    vec4 sobel_edge_v = n[0] + (n[1] * 2) + n[2] - (n[6] + (n[7] * 2) + n[8]);
    vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));
    fragColor = vec4(sobel.rgb, 1.0);
}


