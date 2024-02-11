//Vertex Shader Only//
//Basic Vertex Shader Used By Most Programs//

#ifdef VERTEX_SHADER

varying vec2 TexCoords;

void main() {
    gl_Position = ftransform();
    TexCoords = gl_MultiTexCoord0.st;
}

#endif