#version 120

#include "/common.glsl"

uniform sampler2D colortex0; // The base color texture
uniform sampler2D depthtex0; // The depth buffer

uniform vec3 skyColor;

uniform float far;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;

vec3 projectAndDivide (mat4 projectionMatrix, vec3 position) {
 vec4 homogeneousPos = projectionMatrix * vec4(position, 1.0);
 return homogeneousPos.xyz / homogeneousPos.w;
}

varying vec2 TexCoords;

void main() {
  vec4 baseColor = texture(colortex0, TexCoords);
  float depth = texture(depthtex0, TexCoords).r;

 // Transform the world position to light space
  vec3 screenPos = vec3(TexCoords, depth);
  vec3 ndcPos = screenPos * 2 - 1;
  vec3 veiwPos = projectAndDivide(gbufferProjectionInverse, ndcPos);

  vec4 finalColor = vec4(mix(baseColor.xyz, skyColor, normalisedInRange(far/5, far, veiwPos.z)), baseColor.w);

  gl_FragColor = finalColor;
}