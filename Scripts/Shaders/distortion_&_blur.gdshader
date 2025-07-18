shader_type canvas_item;

uniform float yaxis;
uniform vec2 fov = vec2(0.37, 0.37);
uniform vec2 stretch = vec2(58.0, 54.0);
uniform float blur_amount: hint_range(0.0, 2) = 0.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap_anisotropic;

float fit_to_img(float full_lat, float str) {
    return (full_lat/str);
}

void fragment() {
    // First apply distortion
    vec2 uv = vec2(TAU,PI) * (SCREEN_UV - 0.5) * fov;
    float set = sqrt(uv.x * uv.x + uv.y * uv.y);
    float atset = atan(set);
    float siatset = sin(atset);
    float cosset = cos(atset);
    
    float long = atan(uv.x * siatset, 
        (set * cos(yaxis) * cosset - uv.y * sin(yaxis) * siatset)) / (TAU) + 0.5;
    
    float lati = asin(cosset * sin(yaxis) + 
        (uv.y * siatset * cos(yaxis)) / set) / PI + 0.5;
    
    vec2 pers = vec2(long, lati);
    vec2 imst;
    imst.x = fit_to_img(180.0, stretch.x);
    imst.y = fit_to_img(90.0, stretch.y);
    
    pers *= imst;
    pers -= (imst/2.0)-0.5;
    
    // Then apply blur to the distorted result
    COLOR = texture(SCREEN_TEXTURE, pers, blur_amount);
}