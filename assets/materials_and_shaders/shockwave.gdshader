shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 center_uv = vec2(0.5, 0.5);
uniform float current_radius : hint_range(0.0, 1.5) = 0.0;
uniform float wave_thickness : hint_range(0.0, 0.5) = 0.04;
uniform float distortion_force : hint_range(0.0, 0.2) = 0.06;
uniform float wave_height_uv : hint_range(0.0, 0.5) = 0.1; 

void fragment() {
    float dx = abs(SCREEN_UV.x - center_uv.x);
    float dy = abs(SCREEN_UV.y - center_uv.y);
    
    // Limits the vertical window boundary cleanly (no boxes)
    float vertical_mask = smoothstep(wave_height_uv, wave_height_uv * 0.85, dy);
    
    // Track distance relative to traveling wave ring front line
    float dist_from_wave = abs(dx - current_radius);
    float wave_mask = smoothstep(wave_thickness, 0.0, dist_from_wave) * vertical_mask;
    float wave_profile = sin(wave_mask * PI);
    
    float direction = sign(SCREEN_UV.x - center_uv.x);
    vec2 distorted_uv = SCREEN_UV;
    
    // Shift UV lookup mapping outward to create glass refraction ripple
    distorted_uv.x -= direction * wave_profile * distortion_force;
    
    vec4 background_scene = texture(SCREEN_TEXTURE, distorted_uv);
    
    // Generate slate grey chromatic color sheen highlights
    vec4 red_tint = vec4(0.341, 0.396, 0.408, 1.0);
    vec4 yellow_tint = vec4(0.341, 0.396, 0.408, 1.0);
    vec4 dynamic_glow = mix(red_tint, yellow_tint, wave_mask);
    
    float active_intensity = step(0.001, current_radius) * step(current_radius, 1.4);
    float final_blend_power = wave_profile * 0.25 * active_intensity;
    
    COLOR = mix(background_scene, dynamic_glow, final_blend_power);
}
