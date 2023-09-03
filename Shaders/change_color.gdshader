shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 bright_color : source_color;
uniform vec4 dark_color : source_color;


void fragment() {
    vec4 curr_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 white_key_color = vec4(1,1,1,1);
	vec4 black_key_color = vec4(0,0,0,1);

    if (curr_color == white_key_color){
        COLOR = bright_color;
    }
	else if (curr_color == black_key_color){
        COLOR = dark_color;
    }
	else{
		COLOR = curr_color;
	}
}