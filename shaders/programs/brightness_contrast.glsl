//Fragment Shader Only//
//Vertex uses commonVertex.glsl//
#define CONTRAST 1.2  // Contrast [0.3 0.4 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7]
#define BRIGHTNESS 0.09  // Brightness [0.03 0.04 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15]
#define AMBIENT_OCCLUSION 1.0  // AO Level [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#ifdef FRAGMENT_SHADER

varying vec2 TexCoords;
uniform sampler2D colortex0;

const float ambientOcclusionLevel = AMBIENT_OCCLUSION;

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);

    vec4 albedo = CONTRAST * (basecolor - vec4(0.5, 0.5, 0.5, 0)) + 0.5 + BRIGHTNESS;
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}

#endif