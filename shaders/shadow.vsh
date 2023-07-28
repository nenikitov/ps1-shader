#version 430 compatibility

#include "/lib/distort.glsl"

varying vec2 fTexCoords;
varying vec4 fColor;

void main() {
    gl_Position = ftransform();
    gl_Position.xy = distortPositionToCenter(gl_Position.xy);

    fTexCoords = gl_MultiTexCoord0.st;
    fColor = gl_Color;
}

// vim: filetype=glsl
