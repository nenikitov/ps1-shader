#version 430 compatibility

// Settings
#include "/settings/settings.glsl"

// Libraries

// Ins
in vec2 fCoordTexture;

// Uniforms
uniform sampler2D colortex0;

// Constants

// Functions

// Program
void main() {
    vec4 color = texture2D(colortex0, fCoordTexture);

    gl_FragData[0] = vec4(color.rgb, 1.0);
}
