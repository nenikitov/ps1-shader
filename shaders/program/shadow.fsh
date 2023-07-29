// Settings
#include "/settings/settings.glsl"

// Libraries

// Ins
in vec2 fTexCoords;
in vec4 fColor;

// Outs

// Uniforms
uniform sampler2D texture;

// Constants

// Functions

// Program
void main() {
    gl_FragData[0] = texture2D(texture, fTexCoords) * fColor;
}
