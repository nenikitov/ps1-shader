#version 430 compatibility

// Settings
#include "/settings/settings.glsl"

// Libraries

// Ins
in vec2 fCoordTexture;
in vec4 fColor;

// Outs

// Uniforms
uniform sampler2D colortex0;

// Constants

// Functions

// Program
void main() {
    vec4 color = texture2D(colortex0, fCoordTexture) * fColor;
    gl_FragData[0] = color;
}
