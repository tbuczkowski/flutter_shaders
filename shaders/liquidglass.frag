// I took the shader by forestkatsch on shadertoy (https://www.shadertoy.com/view/WccXDj) and adapted it to work in flutter

#version 460 core
#include <flutter/runtime_effect.glsl>

#define WIDTH (80.0)
#define HEIGHT (40.0)

out vec4 fragColor;
uniform vec2 resolution;
uniform float iTime;
uniform sampler2D image;

// Signed distance function for a rounded rectangle
float sdRoundedRect(vec2 pos, vec2 halfSize, vec4 cornerRadius) {
    // Choose radius based on quadrant
    cornerRadius.xy = (pos.x > 0.0) ? cornerRadius.xy : cornerRadius.zw;
    cornerRadius.x  = (pos.y > 0.0) ? cornerRadius.x  : cornerRadius.y;
    
    vec2 q = abs(pos) - halfSize + cornerRadius.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - cornerRadius.x;
}

// Wrapper for box SDF
float boxSDF(vec2 uv) {
    return sdRoundedRect(uv, vec2(WIDTH, HEIGHT), vec4(HEIGHT));
}

// 2D hash function
vec2 randomVec2(vec2 co) {
    return fract(sin(vec2(
        dot(co, vec2(127.1, 311.7)),
        dot(co, vec2(269.5, 183.3))
    )) * 43758.5453);
}

// Sample texture with added noise-based offset
vec3 sampleWithNoise(vec2 uv, float timeOffset, float mipLevel) {
    vec2 offset = randomVec2(uv + vec2(iTime + timeOffset)) / resolution.x;
    return texture(image, uv + offset * pow(2.0, mipLevel)).rgb;
}

// Get blurred color from multiple noisy samples
vec3 getBlurredColor(vec2 uv, float mipLevel) {
    return (
    sampleWithNoise(uv, 0.0, mipLevel) +
    sampleWithNoise(uv, 0.25, mipLevel) +
    sampleWithNoise(uv, 0.5, mipLevel) +
    sampleWithNoise(uv, 0.75, mipLevel) +
    sampleWithNoise(uv, 1.0, mipLevel) +
    sampleWithNoise(uv, 1.25, mipLevel) +
    sampleWithNoise(uv, 1.5, mipLevel) +
    sampleWithNoise(uv, 1.75, mipLevel) +
    sampleWithNoise(uv, 2.0, mipLevel)
    ) * 0.1;
}

vec3 saturate(vec3 color, float factor) {
    float gray = dot(color, vec3(0.299, 0.587, 0.114)); // luminance
    return mix(vec3(gray), color, factor);
}

// Compute refractive offset from SDF using screen-space gradients
vec2 computeRefractOffset(float sdf) {
    if (sdf < 0.1) {
      return vec2(0.0);
    }

    vec2 grad = normalize(vec2(dFdx(sdf), dFdy(sdf)));
    float offsetAmount = pow(abs(sdf), 12.0) * -0.1;
    return grad * offsetAmount;
}

// Compute refractive offset from SDF using screen-space gradients
float highlight(float sdf) {
    if (sdf < 0.1) {
      return 0.0;
    }

    vec2 grad = normalize(vec2(dFdx(sdf), dFdy(sdf)));
    return 1.0 - clamp(pow(1.0 - abs(dot(grad, vec2(-1.0, 1.0))), 0.5), 0.0, 1.0);
}

// Main shader logic
void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 centeredUV = fragCoord - vec2(mod(iTime * 20, resolution.x) / resolution.x * (resolution.x + 160.0) - 80.0, resolution.y / 2);
    float sdf = boxSDF(centeredUV);

    float normalizedInside = (sdf / HEIGHT) + 1.0;
    float edgeBlendFactor = pow(normalizedInside, 12.0);

    vec3 baseTex = texture(image, (fragCoord / resolution.xy)).rgb;

    vec2 sampleUV = fragCoord / resolution.xy + computeRefractOffset(normalizedInside);
    float mipLevel = mix(2.5, 1.0, edgeBlendFactor);
    vec3 blurredTex = getBlurredColor(sampleUV, mipLevel) * 0.8 + 0.2;
    blurredTex = mix(blurredTex, pow(saturate(blurredTex, 2.0), vec3(0.5)), edgeBlendFactor);
    
    blurredTex += mix(0.0, 0.5, clamp(highlight(normalizedInside) * pow(edgeBlendFactor, 5.0), 0.0, 1.0));

    float boxMask = 1.0 - clamp(sdf, 0.0, 1.0);
    fragColor = vec4(mix(baseTex, blurredTex, vec3(boxMask)), 1.0);
}