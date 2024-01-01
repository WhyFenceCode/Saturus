#version 120

#include "/distort.glsl"

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

uniform vec3 shadowLightPosition;

const int KERNEL_SIZE = 3;

vec3 projectAndDivide (mat4 projectionMatrix, vec3 position) {
 vec4 homogeneousPos = projectionMatrix * vec4(position, 1.0);
 return homogeneousPos.xyz / homogeneousPos.w;
}

float PCF(sampler2D shadowMap, vec2 texCoords, float z, float bias) {
  float shadow = 0.0;
  for (int x = -KERNEL_SIZE / 2; x <= KERNEL_SIZE / 2; ++x) {
      for (int y = -KERNEL_SIZE / 2; y <= KERNEL_SIZE / 2; ++y) {
          float pcfDepth = texture2D(shadowMap, texCoords + vec2(x, y) / textureSize(shadowMap, 0)).r;
          shadow += step(pcfDepth, z - bias);
      }
  }
  return shadow / float((KERNEL_SIZE * KERNEL_SIZE));
}

varying vec2 TexCoords;
varying float lightDot;

void main() {
 vec4 baseColor = texture(colortex0, TexCoords);
 float depth = texture(depthtex0, TexCoords).r;

 // Transform the world position to light space
 vec3 screenPos = vec3(TexCoords, depth);
 vec3 ndcPos = screenPos * 2 - 1;
 vec3 viewPos = projectAndDivide(gbufferProjectionInverse, ndcPos);
 vec3 playerFeetPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
 vec3 shadowViewPos = (shadowModelView * vec4(playerFeetPos, 1.0)).xyz;
 vec3 shadowNdcPos = projectAndDivide(shadowProjection, shadowViewPos);

 shadowNdcPos.xyz = distort(shadowNdcPos.xyz);

 float bias = computeBias(shadowNdcPos);

 vec3 shadowScreenPos = shadowNdcPos * 0.5 + 0.5;

 shadowScreenPos.z -= bias;

 float shadowDepth = texture2D(shadowtex0, shadowScreenPos.xy).r;

 float shadowIntensity = PCF(shadowtex0, shadowScreenPos.xy, shadowScreenPos.z, bias);

 // Mix the shadow color with the base color based on the shadow intensity
 vec4 finalColor = mix(baseColor, vec4(0.039, 0.0, 0.059, 1.0), shadowIntensity/3);

 gl_FragColor = finalColor;
}
