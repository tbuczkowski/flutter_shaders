#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;

out vec4 fragColor;

vec3 cyan = vec3(0, 255, 255) / 255;
vec3 pink = vec3(255, 192, 203) / 255;
vec3 orange = vec3(255, 165, 0) / 255;

void main() {
    vec2 st = FlutterFragCoord().xy / resolution.xy;;

    vec3 color = vec3(0.0);
    vec3 percent = vec3((st.x + st.y) / 1.2);

    color =
    mix(
    mix(orange, pink, percent * 2),
    mix(pink, cyan, percent * 2 - 1),
    step(0.5, percent)
    );

    fragColor = vec4(color, 1);
}

