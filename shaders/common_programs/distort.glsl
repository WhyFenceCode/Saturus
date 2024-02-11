const int shadowMapResolution = 2048;

vec3 distort(vec3 pos) {
    float factor = length(pos.xy) + 0.5;
    return vec3(pos.xy / factor, pos.z * 0.5);
}

float computeBias(vec3 pos) {
    float numerator = length(pos.xy) + 0.1;
    numerator *= numerator;
    return 0.5 / shadowMapResolution * numerator / 0.1;
}