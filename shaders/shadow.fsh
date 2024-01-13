#version 120

varying vec2 uv;
uniform sampler2D gtexture;

void main() {
  gl_FragColor = texture2D(gtexture, uv);
}