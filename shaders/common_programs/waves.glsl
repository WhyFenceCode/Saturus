float wave(float pos){

  float a = sin(pos) * 0.5;
  float b = cos(5.43 * pos) * 0.4;
  float c = sin(8.72 * pos) * 0.3;
  float d = cos(17.3 * pos) * 0.2;
  float e = sin(23.7 * pos) * 0.1;

  return (a + b + c + d + e) * 0.4;
}

vec3 generateWave(vec3 pos, float time) {

  float xadd = pos.x + (0.2 * pos.y) + (0.2 * pos.z) + time;
  float yadd = pos.y + (0.2 * pos.x) + (0.2 * pos.z) + time;
  float zadd = pos.z + (0.2 * pos.y) + (0.2 * pos.x) + time;

  float xpos = pos.x + wave(xadd) * 0.2;
  float ypos = pos.y + wave(yadd) * 0.2;
  float zpos = pos.z + wave(zadd) * 0.2;

  return vec3(xpos, ypos, zpos);
  
}

vec3 generateWaveY(vec3 pos, float time) {

  float yadd = pos.y + (0.2 * pos.x) + (0.2 * pos.z) + time;

  float ypos = pos.y + wave(yadd) * 0.2;

  return vec3(pos.x, ypos, pos.z);
  
}