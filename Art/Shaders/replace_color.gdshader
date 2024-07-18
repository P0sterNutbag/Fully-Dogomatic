shader_type canvas_item;

render_mode blend_mix;
uniform vec4 modulate: source_color;
uniform float alpha = 1;

void fragment() {
	COLOR = vec4(modulate.rgb, texture(TEXTURE, UV).a * alpha);
}

