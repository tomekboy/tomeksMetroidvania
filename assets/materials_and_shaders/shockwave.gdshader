shader_type canvas_item;

// The epicenter of the shockwave in normalized screen UV coordinates (0.0 to 1.0)
uniform vec2 center = vec2(0.5, 0.5);
// Current radius/expansion of the wave ring
uniform float size : hint_range(0.0, 1.5) = 0.0;
// Maximum displacement intensity of the pixels
uniform float force = 0.05;
// Thickness of the shockwave ring edge
uniform float thickness = 0.1;

// Built-in uniform to sample the screen behind the canvas item
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // 1. Maintain correct aspect ratio to prevent the wave from stretching into an oval
    vec2 aspect_ratio = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
    vec2 scaled_uv = SCREEN_UV * aspect_ratio;
    vec2 scaled_center = center * aspect_ratio;
    
    // 2. Measure distance from the fragment to the shockwave center
    float mask_dist = distance(scaled_uv, scaled_center);
    
    // 3. Generate a smooth ring mask based on size and thickness
    float mask = smoothstep(size, size - thickness, mask_dist) * smoothstep(size - thickness * 2.0, size - thickness, mask_dist);
    
    // 4. Calculate displacement vector pointing away from the center
    vec2 disp_dir = normalize(SCREEN_UV - center);
    vec2 displacement = disp_dir * force * mask;
    
    // 5. Sample the screen texture with the offset coordinates
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - displacement);
}
