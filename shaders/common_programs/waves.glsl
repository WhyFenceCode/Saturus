float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
   vec3 a = floor(p);
   vec3 d = p - a;
   d = d * d * (3.0 - 2.0 * d);

   vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
   vec4 k1 = perm(b.xyxy);
   vec4 k2 = perm(k1.xyxy + b.zzww);

   vec4 c = k2 + a.zzzz;
   vec4 k3 = perm(c);
   vec4 k4 = perm(c + 1.0);

   vec4 o1 = fract(k3 * (1.0 / 41.0));
   vec4 o2 = fract(k4 * (1.0 / 41.0));

   vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
   vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

   return o4.y * d.y + o4.x * (1.0 - d.y);
}

float sineWave(vec3 pos, float freq, float amp, float time) {
  return sin(dot(pos, vec3(freq)) + time * amp);
}

float sinSixWave(vec3 pos, float freq, float amp, float time) {
  return pow(sin(dot(pos, vec3(freq)) + time * amp), 6.0);
}

float fbm(vec3 x, int octaves, float lacunarity, float gain) {
   float v = 0.0;
   float a = 0.5;
   vec3 shift = vec3(100.0);
   for (int i = 0; i < octaves; ++i) {
       v += a * noise(x);
       x = x * lacunarity + shift;
       a *= gain;
   }
   return v;
}

float generateWave(float x, float y, float time) {
  vec3 pos = vec3(x, y, time);
  
  // Base layer
  float z = fbm(pos, 4.0, 2.0, 0.5);
  
  // Add sine wave
  z += sineWave(pos, 1.0, 1.0, time);
  
  // Add sin^6 wave
  z += sinSixWave(pos, 1.0, 1.0, time);
  
  // Add another layer of noise with higher frequency and amplitude
  z += fbm(pos * 2.0, 8.0, 4.0, 0.25);
  
  // Add another sine wave with higher frequency and amplitude
  z += sineWave(pos * 2.0, 2.0, 2.0, time);
  
  // Add another sin^6 wave with higher frequency and amplitude
  z += sinSixWave(pos * 2.0, 2.0, 2.0, time);
  
  return z;
}