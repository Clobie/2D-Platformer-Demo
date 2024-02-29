shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	vec4 pxColor = texture(screen_texture, SCREEN_UV);
	float br = (pxColor.r + pxColor.g + pxColor.b) / 3.0;
	vec4 greyscale = vec4(br, br, br, 1.0);
	COLOR.rgba = greyscale;
}
