#version 120

const int PIXELIZATION = 4;
const int COLOR_DEPTH = 12;
const float DITHER_STRENGTH = 0.02;

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

vec2 resolution = vec2(viewWidth, viewHeight);

struct PixelatedCoords {
    vec2 screen;
    ivec2 index;
};

PixelatedCoords pixelateCoords(vec2 coords, int pixels) {
    vec2 index = floor(coords * resolution / pixels);
    vec2 screen = index / resolution * pixels;
    return PixelatedCoords(screen, ivec2(index));
}

vec3 dither(vec3 color, ivec2 index, float strength) {
    ivec2 indexDither = index % 4;
    float dither = ditherPattern[indexDither[0]][indexDither[1]];

    return color + vec3(dither / 15 - 0.5) * strength;
}

vec3 decreaseColorDepth(vec3 color, int depth) {
    return floor(color * depth) / depth;
}

void main() {
    PixelatedCoords coords = pixelateCoords(TexCoords, PIXELIZATION);
    vec3 color = texture2D(
        colortex0,
        coords.screen
    ).rgb;

    color = decreaseColorDepth(
        dither(color, coords.index, DITHER_STRENGTH),
        COLOR_DEPTH
    );

    gl_FragColor = vec4(color, 1.0);
}

// vim: filetype=glsl
