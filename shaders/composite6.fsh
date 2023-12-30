#version 120

uniform sampler2D colortex0; // The base color texture
uniform sampler2D shadowtex0; // The shadow map
uniform sampler2D depthtex0; // The depth buffer
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;

vec3 projectAndDivide (mat4 projectionMatrix, vec3 position) {
  vec4 homogeneousPos = projectionMatrix * vec4(position, 1.0);
  return homogeneousPos.xyz/ homogeneousPos.w;
}

varying vec2 TexCoords;

void main() {
  vec4 baseColor = texture2D(colortex0, TexCoords);
  float depth = texture2D(depthtex0, TexCoords).r;

  // Transform the world position to light space
  vec3 screenPos = projectAndDivide(shadowProjection, (shadowModelView * vec4((gbufferModelViewInverse * vec4(projectAndDivide(gbufferProjectionInverse, vec3(TexCoords, texture2D(depthtex0, TexCoords).r) * 2 - 1), 1.0)).xyz, 1.0).xyz)) * 0.5 + 0.5;

  float shadowDepth = texture2D(shadowtex0, screenPos.xy).r;

  float shadowIntensity = step(shadowDepth, screenPos.z);

  // Mix the shadow color with the base color based on the shadow intensity
  vec4 finalColor = mix(baseColor, vec4(0.0, 0.0, 0.0, 1.0), shadowIntensity); // Shadow color is black

  gl_FragColor = finalColor;
}
