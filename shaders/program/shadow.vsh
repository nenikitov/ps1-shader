// Settings
#include "/settings/settings.glsl"

// Libraries
#include "/lib/distort.glsl"

// Ins

// Outs
out vec2 fTexCoords;
out vec4 fColor;

// Uniforms

// Constants

// Functions

// Program
void main() {
    gl_Position = ftransform();
    gl_Position.xy = distortPositionToCenter(gl_Position.xy);

    fTexCoords = gl_MultiTexCoord0.st;
    fColor = gl_Color;
}
