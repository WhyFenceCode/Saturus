//Fragment Shader Only//
//Vertex uses commonVertex.glsl//

#ifdef FRAGMENT_SHADER

varying vec2 TexCoords;
uniform sampler2D colortex0;

const float saturation = 1.2f;

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);
    basecolor = rgbToHsv(basecolor);
    basecolor.y = basecolor.y * saturation;

    vec4 albedo = hsvToRgb(basecolor);
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}

#endif