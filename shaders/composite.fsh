#version 430 compatibility

#include "/settings/settings.glsl"
#include "/lib/distort.glsl"

const int shadowSamplesPerSize = 2 * shadowPcfSamples + 1;
const int shadowSamplesTotal = shadowSamplesPerSize * shadowSamplesPerSize;

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
    return step(coords.z - shadowBias, texture2D(map, coords.xy).r);
}

vec3 shadowTransparent(in vec3 coords) {
    float opaque = shadowSample(shadowtex0, coords);
    float transparent = shadowSample(shadowtex1, coords);
    vec4 color = texture2D(shadowcolor0, coords.xy);
    vec3 transmitted = color.rgb * (1.0 - color.a);
    return mix(transmitted * transparent, vec3(1.0), opaque);
}

float shadowSpread(in vec3 coords) {
    float distance = 0;
    for (int x = -shadowPcfSamples; x <= shadowPcfSamples; x++) {
        for (int y = -shadowPcfSamples; y <= shadowPcfSamples; y++) {
            vec2 offset = vec2(x, y) * shadowSmoothness / shadowPcfSamples * 0.002;
            vec3 coordsSample = vec3(coords.xy + offset, coords.z);
            float distanceSample =
                texture2D(shadowtex0, coordsSample.xy).r
                + texture2D(shadowtex1, coordsSample.xy).r;
            distance += distanceSample;
        }
    }

    distance /= shadowSamplesTotal * 2;
    distance -= texture2D(shadowtex0, coords.xy).r;

    return max(0, min(4, abs(distance) * 500));
}

vec3 shadowFilter(in vec3 coords) {
    float randomAngle = texture2D(noisetex, fTexCoords * 20.0).r * 100.0;
    float cos = cos(randomAngle);
    float sin = sin(randomAngle);
    mat2 rotation = mat2(cos, -sin, sin, cos) / shadowMapResolution;

    float spread = shadowSpread(coords);

    vec3 shadow = vec3(0.0);
    for (int x = -shadowPcfSamples; x <= shadowPcfSamples; x++) {
        for (int y = -shadowPcfSamples; y <= shadowPcfSamples; y++) {
            vec2 offset = rotation * vec2(x, y) * shadowSmoothness * spread / shadowPcfSamples;
            vec3 coordsSample = vec3(coords.xy + offset, coords.z);
            shadow += shadowTransparent(coordsSample);
        }
    }
    shadow /= shadowSamplesTotal;

    return shadow;
}

vec3 shadow(float depth) {
    if (depth == 1) {
        // Sky
        return vec3(1.0);
    }

    vec3 clipSpace = vec3(fTexCoords, depth) * 2.0 - 1.0;
    vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0);
    vec3 view = viewW.xyz / viewW.w;

    vec4 world = gbufferModelViewInverse * vec4(view, 1.0f);
    vec4 shadowSpace = shadowProjection * shadowModelView * world;
    shadowSpace.xy = distortPositionToCenter(shadowSpace.xy);

    vec3 sampleCoords = shadowSpace.xyz * 0.5 + 0.5;

    return shadowFilter(sampleCoords);
}

void main() {
    vec3 albedo = texture2D(colortex0, fTexCoords).rgb;
    float depth = texture2D(depthtex0, fTexCoords).r;
    vec3 shadow = shadow(depth);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(
        albedo
            * min(shadow + 0.2, 1.0),
        1.0
    );
}

// vim: filetype=glsl
