#version 460 core
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
    vec3[12] c = vec3[12](c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12);
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 3; j++) {
            color += computeIteration(i, j, c[i * 3 + j], pos);
        }
    }
    fragColor = vec4(linearTosRGB(color.r), linearTosRGB(color.g), linearTosRGB(color.b), 1);
}


