//Fragment Shader Only//
//Vertex uses commonVertex.glsl//

#ifdef FRAGMENT_SHADER

varying vec2 TexCoords;
uniform sampler2D colortex0;

const float contrast = 1.2f;
const float brightness = 0.09f;

const float ambientOcclusionLevel = 1.0f;

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);

    vec4 albedo = contrast * (basecolor - vec4(0.5, 0.5, 0.5, 0)) + 0.5 + brightness;
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}

#endif