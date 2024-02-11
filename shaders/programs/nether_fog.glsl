//Fragment Shader Only//
//Vertex uses commonVertex.glsl//

#ifdef FRAGMENT_SHADER

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

varying vec2 TexCoords;

uniform vec3 skyColor;

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
    vec4 fogtint = vec4(0.8, 0.8, 0.8, 1.0);
    vec4 skyfog = vec4(skyColor, 1.0);

    vec4 fog = mix(fogtint, skyfog, 0.5);

    vec4 baseColor = texture(colortex0, TexCoords);
    float depth = texture(depthtex0, TexCoords).r;

    float lineardeapth = linearizeDepthFast(depth);

    vec4 finalColor = mix(baseColor, fog, 1-beerLambertVisibility(2, lineardeapth));

    //vec4 finalColor = vec4(1-beerLambertVisibility(10, lineardeapth), 1-beerLambertVisibility(10, lineardeapth), 1-beerLambertVisibility(10, lineardeapth), 1);

    gl_FragColor = finalColor;
}

#endif