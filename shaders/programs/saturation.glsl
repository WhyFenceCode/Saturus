//Fragment Shader Only//
//Vertex uses commonVertex.glsl//
#define SATURATION 1.4  // Saturation Amount [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]

#ifdef FRAGMENT_SHADER

varying vec2 TexCoords;
uniform sampler2D colortex0;

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);
    basecolor = rgbToHsv(basecolor);
    basecolor.y = basecolor.y * SATURATION;

    vec4 albedo = hsvToRgb(basecolor);
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}

#endif