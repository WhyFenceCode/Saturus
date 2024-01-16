#version 120

uniform sampler2D colortex9;
uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform float far;

uniform mat4 gbufferProjectionInverse;

varying vec2 TexCoords;

vec3 projectAndDivide (mat4 projectionMatrix, vec3 position) {
 vec4 homogeneousPos = projectionMatrix * vec4(position, 1.0);
 return homogeneousPos.xyz / homogeneousPos.w;
}

void main() {
    vec3 screenpos = vec3(TexCoords, texture2D(depthtex0, TexCoords).r);
    vec3 ndcpos = screenpos * 2.0 - 1.0;
    vec3 veiwPos = projectAndDivide(gbufferProjectionInverse, ndcpos);

    float depth = length(veiwPos.z)/far;

    vec4 color = texture2D(colortex0, TexCoords);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = color;
}