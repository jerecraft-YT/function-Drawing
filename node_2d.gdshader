shader_type canvas_item;
uniform sampler2D mask_texture;

void fragment() {
    vec4 mask_color = texture(mask_texture, UV);
    // Si el píxel de la máscara es transparente, descartar
    if (mask_color.a < 0.1) {
        discard;
    }
    COLOR = texture(TEXTURE, UV);
}