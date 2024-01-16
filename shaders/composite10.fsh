#version 120

uniform sampler2D colortex9;
uniform float viewWidth;

const int blurRadius = 10;

varying vec2 TexCoords;

void main() {
   vec4 sum = vec4(0.0);
   vec2 step = 1.0 / viewWidth;

   for (int i = -blurRadius; i <= blurRadius; ++i) {
       sum += texture2D(colortex9, TexCoords + vec2(i, 0.0) * step);
   }

   /* DRAWBUFFERS:0 */
    gl_FragData[0] = sum / (2.0 * blurRadius + 1.0);
}
