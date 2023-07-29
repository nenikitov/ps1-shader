#version 430 compatibility

// Settings
#include "/settings/settings.glsl"

// Libraries
#include "/lib/shadow_distort.glsl"

// Ins

// Outs
out vec2 fCoordTexture;
out vec4 fColor;

// Uniforms

// Constants

// Functions

// Program
void main() {
    fCoordTexture = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    fColor = gl_Color;

    gl_Position = ftransform();
    gl_Position.xyz = shadowDistort(gl_Position.xyz);
}
