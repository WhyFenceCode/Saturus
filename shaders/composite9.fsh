#version 120

uniform sampler2D colortex0;
uniform float viewHeight;

const int blurRadius = 10;

varying vec2 TexCoords;

void main() {
   vec4 sum = vec4(0.0);
   float step = 1.0 / viewHeight;

   for (int i = -blurRadius; i <= blurRadius; ++i) {
       sum += texture2D(colortex0, TexCoords + vec2(0.0, i) * step);
   }

   /* DRAWBUFFERS:9 */
    gl_FragData[0] = sum / (2.0 * blurRadius + 1.0);
}
