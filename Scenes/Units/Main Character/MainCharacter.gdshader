shader_type canvas_item;
uniform vec4 tint : source_color = vec4(0.4117, 0.3137, 0.2745, 1);
void fragment() {
	vec4 tint_copy = tint;
	vec4 previous_color = texture(TEXTURE, UV);
	tint_copy.a = previous_color.a;
	COLOR = tint_copy;
}