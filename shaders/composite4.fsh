#version 120

#include "/distort.glsl"

uniform sampler2D colortex0; // The base color texture
uniform sampler2D colortex2; // The lightmap texture
uniform sampler2D shadowtex0; // The shadow map
uniform sampler2D depthtex0; // The depth buffer
uniform sampler2D colortex15; // The Sunlight LUT

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;

uniform vec3 shadowLightPosition;
uniform int worldTime;

const float pi = 3.1415926535;

float skyBrightness(int time) {
    float squareWave = 0.5 * (sin(pi/12000*(time+500))/sin(pi/8) + 1);
    return clamp(squareWave, 0, 1);
}

vec3 projectAndDivide (mat4 projectionMatrix, vec3 position) {
 vec4 homogeneousPos = projectionMatrix * vec4(position, 1.0);
 return homogeneousPos.xyz / homogeneousPos.w;
}

vec4 lerp3(float t, vec4 v1, vec4 v2, vec4 v3) {
   if (t < 0.7) {
       return mix(v1, v2, t * 2.0);
   } else {
       return mix(v2, v3, (t - 0.7) * 2.0);
   }
}

varying vec2 TexCoords;
varying float lightDot;
varying float BlockID;

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
 for (int x = -2; x <= 2; ++x) {
    for (int y = -2; y <= 2; ++y) {
        vec2 offset = vec2(x, y) / textureSize(shadowtex0, 0);
        float sampleDepth = texture2D(shadowtex0, shadowScreenPos.xy + offset).r;
        shadowIntensity += step(sampleDepth, shadowScreenPos.z);
    }
 }
 shadowIntensity /= 25.0; // Divide by 9 because we sampled 9 times

 vec2 Lightmap = texture2D(colortex2, TexCoords).rg;

 vec4 finalColor = baseColor;

 float lightIntensity = mix(shadowIntensity, 0, Lightmap.x * Lightmap.x * Lightmap.x);

 if (depth != 1.0 && BlockID != 10.0) finalColor = mix(finalColor, vec4(0.039, 0.0, 0.059, 1.0), lightIntensity/2.5); // Shadow color is purple
 if (depth != 1.0 && BlockID != 10.0) finalColor = mix(finalColor, vec4(1, 0.725, 0.0, 1.0), Lightmap.x * Lightmap.x * Lightmap.x / 15); // Torch Light is orange

  if (depth != 1.0 && BlockID != 10.0) finalColor = mix(finalColor, texture(colortex15, vec2(skyBrightness(worldTime), 0.0)), (1 - lightIntensity) * texture(colortex15, vec2(skyBrightness(worldTime), 0.9)).r);
 
 gl_FragColor = finalColor;
}