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
    if (Color.r < 0.5){
        Albedo = texture2D(texture, TexCoords) * vec4(0.3, 0.3, 0.4, 0.2);
    }

    /* DRAWBUFFERS:0123 */
    // Write the values to the color textures
    gl_FragData[0] = Albedo;
    gl_FragData[1] = vec4(Normal * 0.5f + 0.5f, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[3] = vec4(BlockID, 1.0, 1.0, 1.0);
}

#endif