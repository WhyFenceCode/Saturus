#version 120

varying vec2 TexCoords;
uniform sampler2D colortex0;
const float blurRadius = 3.0; // Set your desired blur radius here
uniform float viewWidth;
uniform float viewHeight;

const float PI = 3.14159265358979323846;

// Function to calculate the Gaussian weight
float gaussian(float x, float sigma) {
    return (1.0 / sqrt(2.0 * PI * sigma)) * exp(-(x * x) / (2.0 * sigma));
}

vec4 blurImage(in vec2 fragCoord)
{
    vec3 blur = vec3(0.0);
    float total = 0.0;
    for (int i = -5; i <= 5; i++) {
        for (int j = -5; j <= 5; j++) {
            float weight = gaussian(float(i), blurRadius) * gaussian(float(j), blurRadius);
            float hightCut = j*5 / viewHeight;
            float widthCut = i*5 / viewWidth;
            blur += texture2D(colortex0, fragCoord + vec2(widthCut, hightCut) / 5.0).rgb * weight;
            total += weight;
        }
    }
    return vec4(blur / total, 1.0);
}

float brightness(in vec4 colorToBrighten){
    float brightnessToReturn = (0.299*colorToBrighten.x + 0.587*colorToBrighten.y + 0.114*colorToBrighten.z);
    return brightnessToReturn;
}

vec4 finalComposite(vec4 normalColor, vec4 blurredColor, float brightness){
    vec4 finalColor = mix(normalColor, blurredColor, brightness);
    return finalColor;
}

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);
    vec4 bluredcolor = blurImage(TexCoords);
    float brightness = brightness(bluredcolor);

    vec4 albedo = finalComposite(basecolor, bluredcolor, brightness);
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}