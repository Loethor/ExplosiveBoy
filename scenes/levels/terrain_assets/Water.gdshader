shader_type spatial;

uniform vec3 albedo : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;
uniform vec2 wave_direction = vec2(2.0,0.0);
uniform vec2 wave_direction2 = vec2(2.0,1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;



void fragment() {
	
	// Time calculation for wave (normal map) movement
	vec2 time = (TIME * wave_direction) * time_scale; // Movement rate of first wave
	vec2 time2 = (TIME * wave_direction2) * time_scale; // Movement rate of first wave
	
	// blend normal maps into one
	vec3 normal_blend = mix(texture(texture_normal, UV + time).rgb,
							texture(texture_normal2, UV + time2).rbg,
							 0.5);
	
	ALBEDO = albedo;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
}