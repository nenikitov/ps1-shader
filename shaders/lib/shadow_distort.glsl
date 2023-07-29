// Settings
#include "/settings/settings.glsl"

vec3 shadowDistort(in vec3 pos) {
    #ifdef SHADOW_DISTORT
        float factor = length(pos.xy) + SHADOW_DISTORT_FACTOR;
        return vec3(pos.xy / factor, pos.z * 0.5);
    #else
        return vec3(pos.xy, pos.z * 0.5);
    #endif
}

float shadowBias(in vec3 pos) {
    #ifdef SHADOW_DISTORT
        float factor = length(pos.xy) + SHADOW_DISTORT_FACTOR;
        return SHADOW_BIAS / shadowMapResolution * factor * factor / SHADOW_DISTORT_FACTOR;
    #else
        return SHADOW_BIAS / shadowMapResolution;
    #endif
}
