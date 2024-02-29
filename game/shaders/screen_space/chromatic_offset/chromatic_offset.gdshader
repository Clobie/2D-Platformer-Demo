shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

uniform float offset = 12.0;

void fragment() {
	vec4 cr = texture(screen_texture, SCREEN_UV);
	vec4 cg = texture(screen_texture, vec2(SCREEN_UV.x + (offset * SCREEN_PIXEL_SIZE.x), SCREEN_UV.y));
	vec4 cb = texture(screen_texture, vec2(SCREEN_UV.x - (offset * SCREEN_PIXEL_SIZE.x), SCREEN_UV.y));
	COLOR = vec4( cr.r, cg.g, cb.b, cr.a);
}
