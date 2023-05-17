#version 460 core
#include <flutter/runtime_effect.glsl>

// From
// https://www.shadertoy.com/view/ttlGDf

out vec4 fragColor;

uniform vec2 resolution;
uniform float iTime;

void main(){
    float strength = 0.25;
    float t = iTime/8.0;
    vec3 col = vec3(0);
    vec2 pos = FlutterFragCoord().xy/resolution.xy;
    pos = 4.0*(vec2(0.5) - pos);
    for(float k = 1.0; k < 7.0; k+=1.0){
        pos.x += strength * sin(2.0*t+k*1.5 * pos.y)+t*0.5;
        pos.y += strength * cos(2.0*t+k*1.5 * pos.x);
    }
    col += 0.5 + 0.5*cos(iTime+pos.xyx+vec3(0,2,4));
    col = pow(col, vec3(0.4545));
    fragColor = vec4(col,1.0);
}


