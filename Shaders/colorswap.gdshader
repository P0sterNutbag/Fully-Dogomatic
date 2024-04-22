shader_type canvas_item;

uniform sampler2D palette : filter_nearest, repeat_disable;
uniform bool skip_first_row = true;
uniform bool use_palette_alpha = false;
uniform bool is_texture = true; // Indicates whether the shader is applied to a texture or not
uniform float fps = 6;
uniform float color_threshold = 0.1;

void fragment() {
    vec4 sampled_color;

    if (is_texture) {
        sampled_color = texture(TEXTURE, UV);
    } else {
        sampled_color = COLOR;
    }

    ivec2 color_count = textureSize(palette, 0);

    float idx = -1.0;
    for (int i = 0; i < color_count.x; i++) {
        vec3 palette_color = texture(palette, vec2(float(i) / float(color_count.x - 1), 0)).rgb;

        // Calculate the difference between sampled color and palette color
        vec3 color_diff = abs(sampled_color.rgb - palette_color);

        // Check if the difference is within the threshold
        if (all(lessThanEqual(color_diff, vec3(color_threshold)))) {
            idx = float(i);
            break;
        }
    }

    if (idx >= 0.0) {
        vec2 uv;
        uv.x = idx / float(color_count.x - 1);
        uv.y = (mod(TIME * fps, max(float(color_count.y - 1 - int(skip_first_row)), 1.0)) + float(skip_first_row))  / float(color_count.y - 1);

        vec4 palette_color = texture(palette, uv);

        vec4 final_color = vec4(palette_color.rgb, mix(sampled_color.a, palette_color.a, float(use_palette_alpha)));
        COLOR = final_color;
    } else {
        COLOR = sampled_color;
    }
}
