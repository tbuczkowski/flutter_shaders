#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 outputResolution;
uniform vec3 c1;
uniform vec3 c2;
uniform vec3 c3;
uniform vec3 c4;
uniform vec3 c5;
uniform vec3 c6;
uniform vec3 c7;
uniform vec3 c8;
uniform vec3 c9;
uniform vec3 c10;
uniform vec3 c11;
uniform vec3 c12;

vec3 computeIteration(float x, float y, vec3 color, vec2 pos) {
    float c1 = cos((3.14 * x * pos.x) / outputResolution.x);
    float c2 = cos((3.14 * y * pos.y) / outputResolution.y);
    return color * c1 * c2;
}

float linearTosRGB(float value) {
    float v = max(0, min(1, value));
    if (v <= 0.0031308) {
        return v * 12.92;
    } else {
        return (1.055 * pow(v, 1 / 2.4) - 0.055);
    }
}

void main(){
    vec2 pos = FlutterFragCoord().xy;
    vec3 color = vec3(0,0,0);
    color += computeIteration(0, 0, c1, pos);
    color += computeIteration(1, 0, c2, pos);
    color += computeIteration(2, 0, c3, pos);
    color += computeIteration(3, 0, c4, pos);
    color += computeIteration(0, 1, c5, pos);
    color += computeIteration(1, 1, c6, pos);
    color += computeIteration(2, 1, c7, pos);
    color += computeIteration(3, 1, c8, pos);
    color += computeIteration(0, 2, c9, pos);
    color += computeIteration(1, 2, c10, pos);
    color += computeIteration(2, 2, c11, pos);
    color += computeIteration(3, 2, c12, pos);
    fragColor = vec4(linearTosRGB(color.r), linearTosRGB(color.g), linearTosRGB(color.b), 1);
}