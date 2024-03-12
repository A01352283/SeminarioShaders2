shader_type spatial;

// we will change the render mode for specular to toon because the toon render mode has 
// larger specular highlights
render_mode specular_toon;

// Uniforms allow you to pass data from the game into the shader
//uniform float height_scale = 0.1;
uniform sampler2D noise;
//uniform sampler2D normalmap;

//varying vec2 tex_position;

float wave(vec2 position){
	position += texture(noise, position / 10.0).x * 2.0 - 1.0;
	vec2 wv = 1.0 - abs(sin(position));
	return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(vec2 position, float time) {
  float d = wave((position + time) * 0.4) * 0.3;
  d += wave((position - time) * 0.3) * 0.3;
  d += wave((position + time) * 0.5) * 0.2;
  d += wave((position - time) * 0.6) * 0.2;
  return d;
}

void vertex() {
	// To normalize fo the PlaneMesh coordinates [-1,1] and the texture coordinates [0,1], we divide
	// by the size of the PlaneMesh by 2.0 and add 0.5.
	//tex_position = VERTEX.xz / 2.0 + 0.5;
	//float height = texture(noise, tex_position).x; // texture() returns
	// a vec4 of the r, g, b, a channels, which is the same as xyzw in GLSL.
	//VERTEX.y += height * height_scale;
	
	vec2 pos = VERTEX.xz;
	float k = height(pos, TIME);
	VERTEX.y = k;
	
	NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), TIME), 0.1, k - height(pos + vec2(0.0, 0.1), TIME)));
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	//NORMAL_MAP = texture(normalmap, tex_position).xyz;
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	//Rim lighting increases the effect of light at glancing angles
	RIM = 0.2;
	// A high METALLIC almost ignores ALBEDO altogether, and looks like a mirror of the sky. 
	// While a low METALLIC has a more equal representation of sky color and ALBEDO color.
	METALLIC = 0.0;
	// A low ROUGHNESS will make a material appear like a shiny plastic, 
	// while a high roughness makes the material appear more solid in color.
	ROUGHNESS = 0.01 * (1.0 - fresnel); 
	ALBEDO = vec3(0.01, 0.03, 0.05) + (0.1 * fresnel);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
