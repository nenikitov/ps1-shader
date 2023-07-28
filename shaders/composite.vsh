#version 430 compatibility

varying vec2 fTexCoords;

void main() {
    gl_Position = ftransform();
    fTexCoords = gl_MultiTexCoord0.st;
}

// vim: filetype=glsl
