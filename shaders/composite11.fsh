#version 120

uniform sampler2D colortex9;
uniform sampler2D colortex0;

varying vec2 TexCoords;

void main() {

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = texture2D(colortex0, TexCoords);
}