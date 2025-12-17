shader_type canvas_item;

uniform float start_amp : hint_range(0, 500) = 50.0;
uniform float final_amp : hint_range(0, 500) = 200.0;
uniform float start_angle : hint_range(0.0, 6.28319) = 0.0; // 0 a 2π
uniform float final_angle : hint_range(0.0, 6.28319) = 3.14159;
uniform float line_width : hint_range(0, 20) = 3.0;
uniform float ripple_amplitude : hint_range(0, 50) = 0.0;
uniform float ripple_frequency : hint_range(0, 50) = 10.0;
uniform vec4 line_color : source_color = vec4(1,1,1,1);

void fragment() {
    vec2 uv = (UV - vec2(0.5)) * 2.0; // Normalizamos a [-1,1]
    float r = length(uv) * final_amp;
    float angle = atan(uv.y, uv.x);

    // Normalizamos ángulo entre start y final
    float t = clamp((angle - start_angle) / (final_angle - start_angle), 0.0, 1.0);

    // Aplicar easing si quieres
    t = smoothstep(0.0, 1.0, t);

    // Espiral base
    float spiral_r = mix(final_amp, start_amp, t);

    // Ripple opcional
    spiral_r += cos(t * ripple_frequency * 6.28319) * ripple_amplitude;

    // Grosor
    float d = abs(r - spiral_r);

    if (d < line_width) {
        COLOR = line_color;
    } else {
        discard;
    }
}
