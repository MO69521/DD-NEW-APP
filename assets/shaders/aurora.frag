#version 460 core
#include <flutter/runtime_effect.glsl>

// 极光背景片元着色器（移植自 vue-bits Aurora：simplex noise + 三色渐变 + 垂直衰减）。
// 颜色由 Dart 侧以 uniform 传入（引用设计 token），着色器内不写死任何颜色。

precision highp float;

uniform vec2 uResolution;
uniform float uTime;
uniform float uAmplitude;
uniform float uBlend;
uniform vec3 uColor0;
uniform vec3 uColor1;
uniform vec3 uColor2;

out vec4 fragColor;

vec3 permute(vec3 x) {
  return mod(((x * 34.0) + 1.0) * x, 289.0);
}

// Ashima simplex 2D noise。
float snoise(vec2 v) {
  const vec4 C = vec4(
    0.211324865405187,
    0.366025403784439,
    -0.577350269189626,
    0.024390243902439
  );
  vec2 i = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(
    permute(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0)
  );
  vec3 m = max(
    0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)),
    0.0
  );
  m = m * m;
  m = m * m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

// 三档颜色渐变：0.0 / 0.5 / 1.0。
vec3 rampColor(float t) {
  if (t < 0.5) {
    return mix(uColor0, uColor1, smoothstep(0.0, 0.5, t));
  }
  return mix(uColor1, uColor2, smoothstep(0.5, 1.0, t));
}

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec2 uv = fragCoord / uResolution;
  // Flutter 坐标原点在左上；翻转 y 使极光位于顶部。
  uv.y = 1.0 - uv.y;

  vec3 ramp = rampColor(uv.x);

  float height =
    snoise(vec2(uv.x * 2.0 + uTime * 0.06, uTime * 0.12)) * 0.5 * uAmplitude;
  height = exp(height);
  height = uv.y * 2.0 - height + 0.2;

  float intensity = 0.6 * height;

  float midPoint = 0.20;
  float alpha = smoothstep(
    midPoint - uBlend * 0.5,
    midPoint + uBlend * 0.5,
    intensity
  );

  // 颜色恒为紫色 ramp，仅用 alpha 勾勒极光形状：
  // 深色区透出底层粉色背景，不再因 intensity 压暗而发黑。
  fragColor = vec4(ramp * alpha, alpha);
}
