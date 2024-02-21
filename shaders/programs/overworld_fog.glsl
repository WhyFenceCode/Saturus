//Fragment Shader Only//
//Vertex uses commonVertex.glsl//
#define OVERWORLD_FOG_STRENGTH 0.5  // OverWorld Fog Amount [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define RAIN_FOG_STRENGTH 1.1  // OverWorld Rain Fog Amount [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define THUNDER_FOG_STRENGTH 3.0  // OverWorld Thunder Fog Amount [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]

#ifdef FRAGMENT_SHADER

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

varying vec2 TexCoords;

uniform vec3 skyColor;

uniform float rainStrength;
uniform float thunderStrength;

uniform float far;
uniform float near;

uniform int worldTime;

uniform int isEyeInWater;

const float pi = 3.1415926535;

float skyBrightness(int time) {
    float squareWave = 0.5 * (sin(pi/12000*(time+500))/sin(pi/8) + 1);
    return clamp(squareWave, 0, 1);
}

float linearizeDepthFast(float depth) {
    return (near * far) / (depth * (near - far) + far)/far;
}

float beerLambertVisibility(float concentration, float pathLength) {
    // Define the molar absorptivity for the substance you're working with.
    float epsilon =  1.0;

    // Calculate the attenuation using the Beer-Lambert law.
    float attenuation = epsilon * concentration * pathLength;

    // The visibility is the exponential of the negative attenuation.
    // Clamp the result between  0 and  1 to ensure valid values.
    float visibility = clamp(exp(-attenuation),  0.0,  1.0);

    return visibility;
}

void main() {
    vec4 fog = vec4(skyColor, 1.0);

    vec4 waterfog = vec4(0, 0.2, 0.26, 0.6);

    vec4 baseColor = texture(colortex0, TexCoords);
    float depth = texture(depthtex0, TexCoords).r;

    float lineardeapth = linearizeDepthFast(depth);

    float rainforstreangth = mix(RAIN_FOG_STRENGTH, THUNDER_FOG_STRENGTH, thunderStrength);

    float fogstreangth = mix(OVERWORLD_FOG_STRENGTH, rainforstreangth, rainStrength);

    if (depth != 1.0) fogstreangth = mix(2.1, fogstreangth, skyBrightness(worldTime));

    vec4 finalColor = mix(baseColor, fog, 1-beerLambertVisibility(fogstreangth, lineardeapth));

    if (isEyeInWater == 1){
        finalColor = mix(finalColor, waterfog, 1-beerLambertVisibility(9.0, lineardeapth));
    }

    gl_FragColor = finalColor;
}

#endif