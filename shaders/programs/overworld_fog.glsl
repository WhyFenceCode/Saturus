//Fragment Shader Only//
//Vertex uses commonVertex.glsl//

#ifdef FRAGMENT_SHADER

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

varying vec2 TexCoords;

uniform vec3 skyColor;

uniform float rainStrength;
uniform float thunderStrength;

uniform float far;
uniform float near;

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

    vec4 baseColor = texture(colortex0, TexCoords);
    float depth = texture(depthtex0, TexCoords).r;

    float lineardeapth = linearizeDepthFast(depth);

    float rainforstreangth = mix(1.1, 3, thunderStrength);

    float fogstreangth = mix(0.5, rainforstreangth, rainStrength);

    vec4 finalColor = mix(baseColor, fog, 1-beerLambertVisibility(fogstreangth, lineardeapth));

    gl_FragColor = finalColor;
}

#endif