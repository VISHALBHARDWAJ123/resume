#version 460 core

#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform float uSectionImpact; // 0.0 to 1.0 based on interaction

out vec4 fragColor;

mat2 rot(float a) {
    float c = cos(a), s = sin(a);
    return mat2(vec2(c, s), vec2(-s, c));
}

const float pi = 3.14159265359;
const float pi2 = pi * 2.0;

vec2 pmod(vec2 p, float r) {
    float a = atan(p.x, p.y) + pi / r;
    float n = pi2 / r;
    a = floor(a / n) * n;
    return p * rot(-a);
}

float box(vec3 p, vec3 b) {
    vec3 d = abs(p) - b;
    return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

float ifsBox(vec3 p) {
    for (int i = 0; i < 5; i++) {
        p = abs(p) - 1.0;
        p.xy *= rot(uTime * 0.3 + uSectionImpact * 2.0);
        p.xz *= rot(uTime * 0.1);
    }
    p.xz *= rot(uTime);
    return box(p, vec3(0.4, 0.8 + uSectionImpact * 0.5, 0.3));
}

float map(vec3 p) {
    vec3 p1 = p;
    p1.x = mod(p1.x - 5.0, 10.0) - 5.0;
    p1.y = mod(p1.y - 5.0, 10.0) - 5.0;
    p1.z = mod(p1.z, 16.0) - 8.0;
    // Modulate pmod by section impact
    p1.xy = pmod(p1.xy, 5.0 + floor(uSectionImpact * 3.0));
    return ifsBox(p1);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 p = (fragCoord.xy * 2.0 - uSize.xy) / min(uSize.x, uSize.y);

    vec3 cPos = vec3(0.0, 0.0, -3.0 * uTime);
    vec3 cDir = normalize(vec3(0.0, 0.0, -1.0));
    vec3 cUp = vec3(sin(uTime), 1.0, 0.0);
    vec3 cSide = cross(cDir, cUp);

    vec3 ray = normalize(cSide * p.x + cUp * p.y + cDir);

    float acc = 0.0;
    float acc2 = 0.0;
    float t = 0.0;
    for (int i = 0; i < 60; i++) { // Reduced iterations for performance on web
        vec3 pos = cPos + ray * t;
        float dist = map(pos);
        dist = max(abs(dist), 0.02);
        float a = exp(-dist * 3.0);
        if (mod(length(pos) + 24.0 * uTime, 30.0) < 3.0) {
            a *= 2.0;
            acc2 += a;
        }
        acc += a;
        t += dist * 0.5;
        if (t > 20.0) break;
    }

    // Color changes based on interaction
    vec3 baseCol = mix(vec3(0.01, 0.011, 0.012), vec3(0.02, 0.005, 0.015), uSectionImpact);
    vec3 col = vec3(acc * baseCol.x, acc * baseCol.y + acc2 * 0.002, acc * baseCol.z + acc2 * 0.005);

    // Add interaction highlights
    col += vec3(0.1, 0.2, 0.3) * uSectionImpact * exp(-t * 0.1);

    fragColor = vec4(col, 1.0 - t * 0.03);
}
