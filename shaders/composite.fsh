#version 430 compatibility

#include "/lib/distort.glsl"

#define SHADOW_SAMPLES 2
const int shadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int shadowSamplesTotal = shadowSamplesPerSize * shadowSamplesPerSize;

const int shadowMapResolution = 2048;
const int noiseTextureResolution = 128;

varying vec2 fTexCoords;

// Other
uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;
// Shadow
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;
// Projections
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

float shadowSample(in sampler2D map, in vec3 coords) {
    return step(coords.z - 0.001, texture2D(map, coords.xy).r);
}

vec3 shadowTransparent(in vec3 coords) {
    float opaque = shadowSample(shadowtex0, coords);
    float transparent = shadowSample(shadowtex1, coords);
    vec4 color = texture2D(shadowcolor0, coords.xy);
    vec3 transmitted = color.rgb * (1.0 - color.a);
    return mix(transmitted * transparent, vec3(1.0), opaque);
}

vec3 shadow(float depth) {
    if (depth == 1) {
        return vec3(1.0);
    }

    vec3 clipSpace = vec3(fTexCoords, depth) * 2.0 - 1.0;
    vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0);
    vec3 view = viewW.xyz / viewW.w;

    vec4 world = gbufferModelViewInverse * vec4(view, 1.0f);
    vec4 shadowSpace = shadowProjection * shadowModelView * world;
    shadowSpace.xy = distortPositionToCenter(shadowSpace.xy);

    vec3 sampleCoords = shadowSpace.xyz * 0.5 + 0.5;

    vec3 shadow = vec3(0.0);
    float randomAngle = texture2D(noisetex, fTexCoords * 20.0).r * 100.0;
    float cos = cos(randomAngle);
    float sin = sin(randomAngle);
    mat2 rotation = mat2(cos, -sin, sin, cos) / shadowMapResolution;
    for (int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++) {
        for (int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++) {
            vec2 offset = rotation * vec2(x, y);
            vec3 coords = vec3(sampleCoords.xy + offset, sampleCoords.z);
            shadow += shadowTransparent(coords);
        }
    }
    shadow /= shadowSamplesTotal;

    return shadow;
}

void main() {
    vec3 albedo = texture2D(colortex0, fTexCoords).rgb;
    float depth = texture2D(depthtex0, fTexCoords).r;
    vec3 shadow = min(shadow(depth) + 0.4, 1.0);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(albedo * shadow, 1.0);
}

// vim: filetype=glsl
