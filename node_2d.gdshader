shader_type canvas_item;

uniform float start_angle;
uniform float end_angle;
uniform float start_amp;
uniform float end_amp;
uniform vec2 offset;
uniform int points_count = 64;
uniform float line_width = 2.0;
uniform vec2 viewport_size = vec2(1920.0, 1080.0); // Tamaño por defecto

void fragment() {
    // Convertir UV a coordenadas de pantalla
    vec2 screen_pos = UV * viewport_size;
    COLOR = vec4(0.0); // Fondo transparente

    float total_angle = end_angle - start_angle;
    float total_amp = end_amp - start_amp;

    // Dibujar línea conectando puntos
    for(int i = 0; i < points_count - 1; i++) {
        float progress1 = float(i) / float(points_count - 1);
        float progress2 = float(i + 1) / float(points_count - 1);

        // Punto 1
        float angle1 = radians(start_angle + total_angle * progress1);
        float amp1 = start_amp + total_amp * progress1;
        vec2 point1 = offset + vec2(cos(angle1), -sin(angle1)) * amp1;

        // Punto 2
        float angle2 = radians(start_angle + total_angle * progress2);
        float amp2 = start_amp + total_amp * progress2;
        vec2 point2 = offset + vec2(cos(angle2), -sin(angle2)) * amp2;

        // Distancia a la línea entre point1 y point2
        float dist = distance_to_line_segment(screen_pos, point1, point2);

        if(dist < line_width) {
            COLOR = vec4(1.0, 0.0, 0.0, 1.0);
        }
    }
}

// Función para calcular distancia a un segmento de línea
float distance_to_line_segment(vec2 p, vec2 a, vec2 b) {
    vec2 ab = b - a;
    vec2 ap = p - a;

    float t = clamp(dot(ap, ab) / dot(ab, ab), 0.0, 1.0);
    vec2 closest = a + t * ab;

    return distance(p, closest);
}