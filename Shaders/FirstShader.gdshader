shader_type spatial;

// Uniforms allow you to pass data from the game into the shader
uniform float height_scale = 0.5;
uniform sampler2D noise;
uniform sampler2D normalmap;

varying vec2 tex_position;

void vertex() {
	// To normalize fo the PlaneMesh coordinates [-1,1] and the texture coordinates [0,1], we divide
	// by the size of the PlaneMesh by 2.0 and add 0.5.
	tex_position = VERTEX.xz / 2.0 + 0.5;
	float height = texture(noise, tex_position).x; // texture() returns
	// a vec4 of the r, g, b, a channels, which is the same as xyzw in GLSL.
	VERTEX.y += height * height_scale;
}

void fragment() {
	// Called for every pixel the material is visible on.
	NORMAL_MAP = texture(normalmap, tex_position).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
