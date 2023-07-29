#version 430 compatibility

// Settings
#include "/settings/settings.glsl"

// Libraries

// Outs
out vec2 fCoordTexture;

// Uniforms

// Constants

// Functions

// Program
void main() {
	fCoordTexture = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    gl_Position = ftransform();
}
