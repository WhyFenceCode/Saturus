//Vertex Shader Only//
/////////////////////
#ifdef VERTEX_SHADER

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec3 Normal;
varying vec4 Color;
varying float BlockID;

uniform float sunAngle;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

in vec4 mc_Entity;

void main() {
    vec3 viewpos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    vec3 feetPlayerpos = (gbufferModelViewInverse * vec4(viewpos, 1.0)).xyz;
    vec3 worldpos = feetPlayerpos + cameraPosition;

    worldpos.y += (generateWave(worldpos.x, worldpos.z, sunAngle * 300.0))/20;

    worldpos.y -= 0.1;

    vec3 feetPlayerpos2 = worldpos - cameraPosition;
    vec3 viewpos2 = (gbufferModelView * vec4(feetPlayerpos2, 1.0)).xyz;
    vec4 clippos = gl_ProjectionMatrix * vec4(viewpos2, 1.0);

    // Assign values to varying variables
    TexCoords = gl_MultiTexCoord0.st;
    // Use the texture matrix instead of dividing by 15 to maintain compatiblity for each version of Minecraft
    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
    // Transform them into the [0, 1] range
    LightmapCoords = LightmapCoords * (16.0/15.0) - (16.0/15.0/32.0);
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
    gl_Position = clippos;
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
    gl_FragData[3] = vec4(BlockID, 1.0, 1.0, 1.0);
}

#endif