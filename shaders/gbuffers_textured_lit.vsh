#version 120

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec3 Normal;
varying vec4 Color;
varying float BlockID;

in vec4 mc_Entity;

void main() {
    // Assign values to varying variables
    TexCoords = gl_MultiTexCoord0.st;
    // Use the texture matrix instead of dividing by 15 to maintain compatiblity for each version of Minecraft
    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
    // Transform them into the [0, 1] range
    LightmapCoords = LightmapCoords * (16.0/15.0) - (16.0/15.0/32.0);
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
    gl_Position = ftransform();
    BlockID = mc_Entity.x;
}
