#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uLight;
uniform float uTime;
uniform vec3 uBaseColor;
uniform vec3 uHighlightColor;

out vec4 fragColor;

void main() {
    vec2 frag = FlutterFragCoord().xy;
    vec2 uv = frag / uSize;

    float cycle = fract(uTime * 0.25);
    float fadeIn = smoothstep(0.0, 0.08, cycle);
    float fadeOut = 1.0 - smoothstep(0.78, 0.94, cycle);
    float sweepActive = fadeIn * fadeOut;
    float beamX = clamp(cycle / 0.78, 0.0, 1.0);
    float slantedX = uv.x + (uv.y - 0.5) * 0.16;
    float beamDist = abs(slantedX - beamX);
    float beamBody = smoothstep(0.28, 0.04, beamDist);
    float beamCore = smoothstep(0.11, 0.02, beamDist);
    float beamGlow = (beamBody * 0.24 + beamCore * 0.045) * sweepActive;

    float glow = beamGlow;
    float liquidWave =
        sin(uv.y * 18.0 + uTime * 5.0) *
        sin(uv.x * 10.0 - uTime * 2.0) *
        glow;

    float edgeY = smoothstep(0.10, 0.0, min(uv.y, 1.0 - uv.y));
    float edgeX = smoothstep(0.08, 0.0, min(uv.x, 1.0 - uv.x));
    float edgeField = max(edgeY, edgeX * 0.72);
    float edgeBulge = edgeField * beamGlow;

    vec2 refractOffset = vec2(edgeBulge * 0.006, 0.0);
    float edgeRidge = smoothstep(0.10, 0.0, abs(min(uv.y, 1.0 - uv.y) - 0.08));

    float shade =
        1.0 +
        glow * 0.10 +
        edgeBulge * 0.08 +
        edgeRidge * beamGlow * 0.05 +
        liquidWave * 0.035 -
        length(refractOffset) * 1.15;

    vec3 color = uBaseColor * shade;
    color += uHighlightColor *
        (beamBody * 0.075 + beamCore * 0.028 + edgeBulge * 0.03) *
        sweepActive;

    fragColor = vec4(color, 1.0);
}
