#version 120

varying vec2 TexCoords;
varying float lightDot;

uniform vec3 shadowLightPosition;

void main() {
   gl_Position = ftransform();
   TexCoords = gl_MultiTexCoord0.st;
   lightDot = dot(normalize(shadowLightPosition), normalize(gl_NormalMatrix * gl_Normal));
}
