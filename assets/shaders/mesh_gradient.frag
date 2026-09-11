#version 460 core

#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;

out vec4 fragColor;

// Precision-friendly hash function
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// 2D Noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractional Brownian Motion for nebulae
float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    // Standard mat2 constructor using column vectors
    mat2 m = mat2(vec2(0.8, 0.6), vec2(-0.6, 0.8));
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p = m * p * 2.0;
        a *= 0.5;
    }
    return v;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    float ratio = uSize.x / uSize.y;
    vec2 p = (uv - 0.5);
    p.x *= ratio;

    float t = uTime * 0.05;

    // Slow rotation for the galaxy feel
    float ang = t * 0.2;
    float c = cos(ang);
    float s = sin(ang);
    // Standard rotation matrix constructor
    mat2 rot = mat2(vec2(c, -s), vec2(s, c));
    p = rot * p;

    // Nebula Layer 1 (Deep Blues/Purples)
    vec2 p1 = p * 2.0 + vec2(t, t * 0.5);
    float n1 = fbm(p1);
    vec3 col1 = vec3(0.1, 0.1, 0.4) * n1;

    // Nebula Layer 2 (Magentas/Teals)
    vec2 p2 = p * 3.0 - vec2(t * 0.7, t);
    float n2 = fbm(p2);
    vec3 col2 = vec3(0.4, 0.1, 0.3) * n2;

    // Center Glow
    float dist = length(p);
    float glow = exp(-dist * 4.0);
    vec3 centerCol = vec3(0.8, 0.9, 1.0) * glow;

    // Star Field
    float stars = pow(hash(uv * 500.0), 50.0) * 1.5;
    // Twinkling effect
    stars *= 0.8 + 0.5 * sin(uTime * 2.0 + hash(uv) * 10.0);

    // Mix everything
    vec3 color = mix(col1, col2, n2 * 0.5);
    color += centerCol * 0.3;
    color += stars;

    // Darken edges for deep space feel
    color *= smoothstep(1.2, 0.2, dist);

    fragColor = vec4(color, 1.0);
}
