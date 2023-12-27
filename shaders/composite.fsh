#version 120

varying vec2 TexCoords;
uniform sampler2D colortex0;

const float contrast = 0.8f;
const float brightness = 0.05f;

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);

    vec4 albedo = contrast * (basecolor - vec4(0.5, 0.5, 0.5, 0)) + 0.5 + brightness;
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}