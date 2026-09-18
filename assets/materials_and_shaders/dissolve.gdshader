shader_type canvas_item;

uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_texture;

// Glow customization
uniform vec4 edge_color : source_color = vec4(1.0, 0.3, 0.0, 1.0); // Orange/Red glow
uniform float edge_thickness : hint_range(0.0, 0.1) = 0.03;       // Width of the burn line
uniform float glow_intensity : hint_range(1.0, 5.0) = 2.0;         // Multiplier for bloom/glow

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float noise = texture(noise_texture, UV).r;
    
    // 1. Cut off pixels below the threshold
    if (noise < dissolve_amount) {
        discard;
    }
    
    // 2. Detect pixels that are just above the threshold to create the edge
    if (noise < dissolve_amount + edge_thickness) {
        // Blend the original color with the glowing edge color
        float edge_mix = (dissolve_amount + edge_thickness - noise) / edge_thickness;
        
        // Apply glow intensity (works best if WorldEnvironment HDR/Bloom is enabled)
        vec4 glow = edge_color * glow_intensity;
        
        // Preserve original transparency but apply the glow color
        tex_color.rgb = mix(tex_color.rgb, glow.rgb, edge_mix);
    }
    
    COLOR = tex_color;
}
