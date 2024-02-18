//Vertex Shader Only//
/////////////////////
#ifdef VERTEX_SHADER

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

#endif

//Fragment Shader//
//////////////////
#ifdef FRAGMENT_SHADER

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec3 Normal;
varying vec4 Color;

varying float BlockID;

// The texture atlas
uniform sampler2D texture;

void main(){

    vec4 Albedo = texture2D(texture, TexCoords) * Color;
    /* DRAWBUFFERS:0123 */
    // Write the values to the color textures
    gl_FragData[0] = Albedo;
    gl_FragData[1] = vec4(Normal * 0.5f + 0.5f, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[3] = vec4(float(BlockID), 1.0, 1.0, 1.0);
}

#endif