//Vertex Shader Only//
/////////////////////
#ifdef VERTEX_SHADER

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec3 Normal;
varying vec4 Color;
varying float BlockID;

uniform float sunAngle;
uniform float frameTimeCounter;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

in vec3 mc_Entity;

void main() {
    // Assign values to varying variables
    TexCoords = gl_MultiTexCoord0.st;
    // Use the texture matrix instead of dividing by 15 to maintain compatiblity for each version of Minecraft
    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
    // Transform them into the [0, 1] range
    LightmapCoords = LightmapCoords * (16.0/15.0) - (16.0/15.0/32.0);
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
    BlockID = mc_Entity.x;
    if (mc_Entity.x == 30.0 || mc_Entity.x == 40.0 || mc_Entity.x == 50.0 || mc_Entity.x == 60){
        vec3 viewpos = (gl_ModelViewMatrix * gl_Vertex).xyz;
        vec3 feetPlayerpos = (gbufferModelViewInverse * vec4(viewpos, 1.0)).xyz;
        vec3 worldpos = feetPlayerpos + cameraPosition;

        worldpos.z += (generateWave(worldpos.x, worldpos.y, frameTimeCounter/800 * 200.0))/40;
        worldpos.x += (generateWave(worldpos.z, worldpos.y, frameTimeCounter/800 * 200.0 - 200))/40;

        worldpos.y -= 0.0001;

        vec3 feetPlayerpos2 = worldpos - cameraPosition;
        vec3 viewpos2 = (gbufferModelView * vec4(feetPlayerpos2, 1.0)).xyz;
        vec4 clippos = gl_ProjectionMatrix * vec4(viewpos2, 1.0);

        gl_Position = clippos;
    } else {
        gl_Position = ftransform();
    }
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
uniform sampler2D leavesLUT;

uniform float frameTimeCounter;
uniform float sunAngle;
uniform int worldDay;

// length of each season in minecraft days
// for example, at 1, an entire season is 1 day long
const int SeasonLength = 5;


//Season functions slightly modified based on functions by Xonk
vec4 getStanderdSeasonColor( int worldDay ){

	// loop the year. multiply the season length by the 4 seasons to create a years time.
	float YearLoop = mod(worldDay, SeasonLength * 4);

	// the time schedule for each season
	float SummerTime = clamp(YearLoop                  ,0, SeasonLength) / SeasonLength;
	float AutumnTime = clamp(YearLoop - SeasonLength   ,0, SeasonLength) / SeasonLength;
	float WinterTime = clamp(YearLoop - SeasonLength*2 ,0, SeasonLength) / SeasonLength;
	float SpringTime = clamp(YearLoop - SeasonLength*3 ,0, SeasonLength) / SeasonLength;

	// colors for things
	vec4 SummerCol = texture(leavesLUT, vec2(0.251, 0.0));
	vec4 AutumnCol = texture(leavesLUT, vec2(0.501, 0.0));
	vec4 WinterCol = texture(leavesLUT, vec2(0.751, 0.0));
	vec4 SpringCol = texture(leavesLUT, vec2(0.0, 0.0));

	// lerp all season colors together
	vec4 SummerToFall =   mix(SummerCol,      AutumnCol, SummerTime);
	vec4 FallToWinter =   mix(SummerToFall,   WinterCol, AutumnTime);
	vec4 WinterToSpring = mix(FallToWinter,   SpringCol, WinterTime);
	vec4 SpringToSummer = mix(WinterToSpring, SummerCol, SpringTime);

	// return the final color of the year, because it contains all the other colors, at some point.
	return SpringToSummer;
}

vec4 getSpruceSeasonColor( int worldDay ){

	// loop the year. multiply the season length by the 4 seasons to create a years time.
	float YearLoop = mod(worldDay, SeasonLength * 4);

	// the time schedule for each season
	float SummerTime = clamp(YearLoop                  ,0, SeasonLength) / SeasonLength;
	float AutumnTime = clamp(YearLoop - SeasonLength   ,0, SeasonLength) / SeasonLength;
	float WinterTime = clamp(YearLoop - SeasonLength*2 ,0, SeasonLength) / SeasonLength;
	float SpringTime = clamp(YearLoop - SeasonLength*3 ,0, SeasonLength) / SeasonLength;

	// colors for things
	vec4 SummerCol = texture(leavesLUT, vec2(0.251, 0.9));
	vec4 AutumnCol = texture(leavesLUT, vec2(0.501, 0.9));
	vec4 WinterCol = texture(leavesLUT, vec2(0.751, 0.9));
	vec4 SpringCol = texture(leavesLUT, vec2(0.0, 0.9));

	// lerp all season colors together
	vec4 SummerToFall =   mix(SummerCol,      AutumnCol, SummerTime);
	vec4 FallToWinter =   mix(SummerToFall,   WinterCol, AutumnTime);
	vec4 WinterToSpring = mix(FallToWinter,   SpringCol, WinterTime);
	vec4 SpringToSummer = mix(WinterToSpring, SummerCol, SpringTime);

	// return the final color of the year, because it contains all the other colors, at some point.
	return SpringToSummer;
}

void main(){

    vec4 mixedColor = Color;
    if (BlockID == 30.0){
        mixedColor = mix(Color, getStanderdSeasonColor(worldDay), 0.8);
    }
    if (BlockID == 40.0){
        mixedColor = mix(Color, getSpruceSeasonColor(worldDay), 0.8);
    }

    vec4 Albedo = texture2D(texture, TexCoords) * mixedColor;
    /* DRAWBUFFERS:0123 */
    // Write the values to the color textures
    gl_FragData[0] = Albedo;
    gl_FragData[1] = vec4(Normal * 0.5f + 0.5f, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[3] = vec4(BlockID, 1.0, 1.0, 1.0);
}

#endif