#version 120

varying vec2 TexCoords;
uniform sampler2D colortex0;

uniform float viewWidth;
uniform float viewHeight;

mat4 ditherPattern = mat4(
    vec4(0, 12, 3, 15),
    vec4(8, 4, 11, 7),
    vec4(2, 14, 1, 13),
    vec4(10, 6, 9, 5)
);

vec2 pixelateCoords(vec2 coords, int pixels) {
    vec2 resolution = vec2(viewWidth, viewHeight);
    return floor(coords * resolution / pixels) / resolution * pixels;
}

vec3 dither(vec3 color, ivec2 pos) {

}

vec3 decreaseColorDepth(vec3 color, int depth) {
    return floor(color * depth) / depth;
}

void main() {
    vec2 coords = pixelateCoords(TexCoords, 4);
    vec3 color = texture2D(
        colortex0,
        coords
    ).rgb;

    color = decreaseColorDepth(color, 16);

    gl_FragColor = vec4(color, 1.0);
}

// vim: filetype=glsl
