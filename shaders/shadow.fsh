#version 430 compatibility

varying vec2 fTexCoords;
varying vec4 fColor;

uniform sampler2D texture;

void main() {
    gl_FragData[0] = texture2D(texture, fTexCoords) * fColor;
}

// vim: filetype=glsl
