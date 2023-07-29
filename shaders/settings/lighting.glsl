// Preformance
#define SHADOW_MAP_RESOLUTION 4096
#define SHADOW_DISTANCE 128.0
#define SHADOW_PCF_SAMPLES 4

// Look
#define SHADOW_SMOOTHNESS 1
#define SUN_PATH_ROTATION -40.0

// Technical
#define SHADOW_BIAS 0.001


// Variables
const int shadowMapResolution = SHADOW_MAP_RESOLUTION;
const float shadowDistance = SHADOW_DISTANCE;
const float sunPathRotation = SUN_PATH_ROTATION;
const float shadowSmoothness = shadowMapResolution / 1024.0 * SHADOW_SMOOTHNESS;
const float shadowBias = SHADOW_BIAS / (shadowMapResolution / 1024.0);
const int shadowPcfSamples = SHADOW_PCF_SAMPLES;

