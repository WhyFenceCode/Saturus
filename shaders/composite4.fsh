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

vec3 projectAndDivide (mat4 projectionMatrix, vec3 position) {
 vec4 homogeneousPos = projectionMatrix * vec4(position, 1.0);
 return homogeneousPos.xyz / homogeneousPos.w;
}

varying vec2 TexCoords;
varying float lightDot;

void main() {
 vec4 baseColor = texture(colortex0, TexCoords);
 float depth = texture(depthtex0, TexCoords).r;

 // Transform the world position to light space
 vec3 screenPos = vec3(TexCoords, depth);
 vec3 ndcPos = screenPos * 2 - 1;
 vec3 veiwPos = projectAndDivide(gbufferProjectionInverse, ndcPos);
 vec3 playerFeetPos = (gbufferModelViewInverse * vec4(veiwPos, 1.0)).xyz;
 vec3 shadowViewPos = (shadowModelView * vec4(playerFeetPos, 1.0)).xyz;
 vec3 shadowNdcPos = projectAndDivide(shadowProjection, shadowViewPos);

 shadowNdcPos.xyz = distort(shadowNdcPos.xyz);

 float bias = computeBias(shadowNdcPos);

 vec3 shadowScreenPos = shadowNdcPos * 0.5 + 0.5;

 shadowScreenPos.z -= bias;

 float shadowIntensity = 0.0;
 for (int x = -1; x <= 1; ++x) {
    for (int y = -1; y <= 1; ++y) {
        vec2 offset = vec2(x, y) / textureSize(shadowtex0, 0);
        float sampleDepth = texture2D(shadowtex0, shadowScreenPos.xy + offset).r;
        shadowIntensity += step(sampleDepth, shadowScreenPos.z);
    }
 }
 shadowIntensity /= 9.0; // Divide by 9 because we sampled 9 times

 vec4 finalColor = mix(baseColor, vec4(0.039, 0.0, 0.059, 1.0), shadowIntensity/2.4); // Shadow color is black

 gl_FragColor = finalColor;
}