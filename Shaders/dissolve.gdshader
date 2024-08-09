shader_type canvas_item;

uniform sampler2D noise_text;
uniform float dissolve_pct:hint_range(0.0, 1.0, 0.01) = 0.0f;

uniform float lerp_percent : hint_range(0.0, 1.0, 0.1);

void fragment() 
{
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 black_color = mix(texture_color, vec4(-1.0,-1.0,-1.0, texture_color.a), lerp_percent);
	
	vec4 original_color = texture(TEXTURE,UV);
	vec4 final_color = original_color;
	vec4 noise = texture(noise_text,UV);
	
	if (dissolve_pct >= noise.r)
	{
		final_color.a = 0.0;
	}
	
	final_color.rgb = black_color.rgb;
	
	COLOR = final_color;
}