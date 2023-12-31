#version 120

#include "/distort.glsl"

varying vec2 TexCoords;
const float sunPathRotation = 45.0f;
const float shadowDistance = 200.0f;

uniform vec3 shadowLightPosition;

void main() {
   gl_Position = ftransform();
   TexCoords = gl_MultiTexCoord0.st;
   gl_Position.xyz = distort(gl_Position.xyz);
}
