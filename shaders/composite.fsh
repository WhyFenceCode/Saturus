#version 120

uniform float viewWidth;
uniform float viewHeight;

vec4 blurImage(in vec2 fragCoord)
{
    float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS {{{
    float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    float Quality = 4.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
    float Size = 8.0; // BLUR SIZE (Radius)
    // GAUSSIAN BLUR SETTINGS }}}

    vec3 iResolution = new vec3(viewWidth, viewHeight, 1.0);
   
    vec2 Radius = Size/iResolution.xy;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    // Pixel colour
    vec4 Color = texture(iChannel0, uv);
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += texture( iChannel0, uv+vec2(cos(d),sin(d))*Radius*i);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions - 15.0;
    return Color;
}

float brightness(in vec4 colorToBrighten){
    float brightnessToReturn = (0.299*colorToBrighten.x + 0.587*colorToBrighten.y + 0.114*colorToBrighten.z);
    return brightnessToReturn;
}

vec4 finalComposite(vec4 normalColor, vec4 blurredColor, float brightness){
    vec4 finalColor = mix(normalColor, blurredColor, brightness);
    return finalColor;
}