#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform float width;
uniform float height;
uniform sampler2D image;

void main(){
    vec2 pos = FlutterFragCoord().xy / vec2(width, height);
    vec4 n0 = texture(image, pos + vec2(-1.0, -1.0));
    vec4 n1 = texture(image, pos + vec2(0.0, -1.0));
    vec4 n2 = texture(image, pos + vec2(1.0, -1.0));
    vec4 n3 = texture(image, pos + vec2(-1.0, 0.0));
    vec4 n4 = texture(image, pos);
    vec4 n5 = texture(image, pos + vec2(1.0, 0.0));
    vec4 n6 = texture(image, pos + vec2(-1.0, 1.0));
    vec4 n7 = texture(image, pos + vec2(0.0, 1.0));
    vec4 n8 = texture(image, pos + vec2(1.0, 1.0));
    vec4 sobel_edge_h = n2 + (n5 * 2) + n8 - (n0 + (n3 * 2) + n6);
    vec4 sobel_edge_v = n0 + (n1 * 2) + n2 - (n6 + (n7 * 2) + n8);
    vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));
    fragColor = vec4(sobel.rgb, 1.0);
}


