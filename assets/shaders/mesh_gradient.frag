#version 460 core

#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform float uSectionImpact; // 0.0 to 1.0
uniform float uIsDark;       // 1.0 for dark, 0.0 for light

out vec4 fragColor;

mat2 rot(float a) {
    float c = cos(a), s = sin(a);
    return mat2(c, s, -s, c);
}

const float PI = 3.14159265359;
const float PI2 = 6.28318530718;

vec2 pmod(vec2 p, float r) {
    float n = PI2 / r;
    float a = atan(p.x, p.y) + PI / r;
    a = floor(a / n) * n;
    float c = cos(-a), s = sin(-a);
    return p * mat2(c, s, -s, c);
}

float sdBox(vec3 p, vec3 b) {
    vec3 d = abs(p) - b;
    return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

float ifsBox(vec3 p, mat2 r1, mat2 r2, mat2 r3) {
    for (int i = 0; i < 5; i++) {
        p = abs(p) - 1.0;
        p.xy *= r1;
        p.xz *= r2;
    }
    p.xz *= r3; // Restore the missing global rotation
    return sdBox(p, vec3(0.4, 0.8 + uSectionImpact * 0.5, 0.3));
}

float map(vec3 p, mat2 r1, mat2 r2, mat2 r3, float rCount) {
    vec3 p1 = p;
    p1.x = mod(p1.x - 5.0, 10.0) - 5.0;
    p1.y = mod(p1.y - 5.0, 10.0) - 5.0;
    p1.z = mod(p1.z, 16.0) - 8.0;

    p1.xy = pmod(p1.xy, rCount);
    return ifsBox(p1, r1, r2, r3);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 p = (fragCoord.xy * 2.0 - uSize.xy) / min(uSize.x, uSize.y);

    // Precompute rotations
    mat2 r1 = rot(uTime * 0.3 + uSectionImpact * 2.0);
    mat2 r2 = rot(uTime * 0.1);
    mat2 r3 = rot(uTime);
    float rCount = 5.0 + floor(uSectionImpact * 3.0);

    // Camera animation
    vec3 cPos = vec3(0.0, 0.0, -3.0 * uTime);
    vec3 cDir = normalize(vec3(0.0, 0.0, -1.0));
    vec3 cUp = vec3(sin(uTime * 0.5) * 0.1, 1.0, 0.0);
    vec3 cSide = cross(cDir, cUp);

    vec3 ray = normalize(cSide * p.x + cUp * p.y + cDir);

    float acc = 0.0;
    float acc2 = 0.0;
    float t = 0.0;

    // Balanced iterations for performance and quality
    for (int i = 0; i < 48; i++) {
        vec3 pos = cPos + ray * t;
        float dist = map(pos, r1, r2, r3, rCount);
        dist = max(abs(dist), 0.02);

        float a = exp(-dist * 3.0);

        // Animated highlight pulse
        if (mod(length(pos) + 24.0 * uTime, 30.0) < 3.0) {
            a *= 2.0;
            acc2 += a;
        }
        acc += a;
        t += dist * 0.55;
        if (t > 20.0) break;
    }

    vec3 darkBase = mix(vec3(0.01, 0.011, 0.012), vec3(0.02, 0.005, 0.015), uSectionImpact);
    vec3 lightBase = mix(vec3(0.97, 0.98, 0.99), vec3(0.94, 0.96, 0.99), uSectionImpact);

    vec3 baseCol = mix(lightBase, darkBase, uIsDark);
    vec3 col;

    if (uIsDark > 0.5) {
        col = vec3(acc * baseCol.x, acc * baseCol.y + acc2 * 0.002, acc * baseCol.z + acc2 * 0.005);
        col += vec3(0.1, 0.2, 0.3) * uSectionImpact * exp(-t * 0.1);
    } else {
        float shad = clamp(1.0 - acc * 0.02, 0.0, 1.0);
        col = baseCol * (0.8 + 0.2 * shad);
        col = mix(col, vec3(1.0), acc2 * 0.01);
    }

    float alpha = mix(0.5, 1.0 - t * 0.05, uIsDark);
    fragColor = vec4(col, alpha);
}
