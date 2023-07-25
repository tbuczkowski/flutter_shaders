#version 460 core
#include <flutter/runtime_effect.glsl>

#define PI 3.14159265359
#define SCALE_FACTOR 8
#define TIME_SCALE 0.005

out vec4 fragColor;
uniform vec2 resolution;
uniform float time;

float normalizeTrigonometricFunction(float value) {
    return (value + 1) / 2;
}

void main() {
    vec2 pos = FlutterFragCoord().xy / resolution;
    float scaledTime = time * TIME_SCALE;
    float verticalStripe = normalizeTrigonometricFunction(sin(pos.x * PI * SCALE_FACTOR + scaledTime));
    float horizontalStripe = normalizeTrigonometricFunction(cos(pos.y * PI * SCALE_FACTOR + scaledTime));
    float diagonalStripe = normalizeTrigonometricFunction(sin((pos.x + pos.y) * PI * SCALE_FACTOR + scaledTime));
    vec3 verticalStripeColor = vec3(1.0, 0.0, 0.0) * verticalStripe;
    vec3 horizontalStripeColor = vec3(0.0, 1.0, 0.0) * horizontalStripe;
    vec3 diagonalStripeColor = vec3(0.0, 0.0, 1.0) * diagonalStripe;
    vec3 mixedColor = mix(
        mix(verticalStripeColor, horizontalStripeColor, pos.x),
        diagonalStripeColor,
        pos.y
    );
    fragColor = vec4(mixedColor, 1.0);
}