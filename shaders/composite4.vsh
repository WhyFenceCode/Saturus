#version 120

varying vec2 TexCoords;
varying float lightDot;
varying float BlockID;

uniform vec3 shadowLightPosition;

in vec4 mc_Entity;

void main() {
   gl_Position = ftransform();
   TexCoords = gl_MultiTexCoord0.st;
   lightDot = dot(normalize(shadowLightPosition), normalize(gl_NormalMatrix * gl_Normal));
   BlockID = mc_Entity.x;
}
