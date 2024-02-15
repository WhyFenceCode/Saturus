//Vertex Shader Only//
/////////////////////
#ifdef VERTEX_SHADER

varying vec2 TexCoords;
varying vec2 uv;
const float sunPathRotation = 45.0;
const float shadowDistance = 200.0;

uniform vec3 shadowLightPosition;

void main() {
   gl_Position = ftransform();
   TexCoords = gl_MultiTexCoord0.st;
   uv = gl_MultiTexCoord0.xy;
   gl_Position.xyz = distort(gl_Position.xyz);
}

#endif

//Fragment Shader//
//////////////////
#ifdef FRAGMENT_SHADER

varying vec2 uv;
uniform sampler2D gtexture;

void main() {
  gl_FragColor = texture2D(gtexture, uv);
}

#endif