#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform float pointer;
uniform float origin;
uniform vec4 container;
uniform float cornerRadius;
uniform sampler2D image;

const float r = 150.0;
const float scaleFactor = 0.2;

#define PI 3.14159265359
#define TRANSPARENT vec4(0.0, 0.0, 0.0, 0.0)

mat3 translate(vec2 p) {
    return mat3(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, p.x, p.y, 1.0);
}

mat3 scale(vec2 s, vec2 p) {
    return translate(p) * mat3(s.x, 0.0, 0.0, 0.0, s.y, 0.0, 0.0, 0.0, 1.0) * translate(-p);
}

mat3 inverse(mat3 m) {
    float a00 = m[0][0], a01 = m[0][1], a02 = m[0][2];
    float a10 = m[1][0], a11 = m[1][1], a12 = m[1][2];
    float a20 = m[2][0], a21 = m[2][1], a22 = m[2][2];

    float b01 = a22 * a11 - a12 * a21;
    float b11 = -a22 * a10 + a12 * a20;
    float b21 = a21 * a10 - a11 * a20;

    float det = a00 * b01 + a01 * b11 + a02 * b21;

    return mat3(b01, (-a22 * a01 + a02 * a21), (a12 * a01 - a02 * a11),
    b11, (a22 * a00 - a02 * a20), (-a12 * a00 + a02 * a10),
    b21, (-a21 * a00 + a01 * a20), (a11 * a00 - a01 * a10)) / det;
}

vec2 project(vec2 p, mat3 m) {
    return (inverse(m) * vec3(p, 1.0)).xy;
}

bool inRect(vec2 p, vec4 rct) {
    bool inRct = p.x > rct.x && p.x < rct.z && p.y > rct.y && p.y < rct.w;
    if (!inRct) {
        return false;
    }
    // Top left corner
    if (p.x < rct.x + cornerRadius && p.y < rct.y + cornerRadius) {
        return length(p - vec2(rct.x + cornerRadius, rct.y + cornerRadius)) < cornerRadius;
    }
    // Top right corner
    if (p.x > rct.z - cornerRadius && p.y < rct.y + cornerRadius) {
        return length(p - vec2(rct.z - cornerRadius, rct.y + cornerRadius)) < cornerRadius;
    }
    // Bottom left corner
    if (p.x < rct.x + cornerRadius && p.y > rct.w - cornerRadius) {
        return length(p - vec2(rct.x + cornerRadius, rct.w - cornerRadius)) < cornerRadius;
    }
    // Bottom right corner
    if (p.x > rct.z - cornerRadius && p.y > rct.w - cornerRadius) {
        return length(p - vec2(rct.z - cornerRadius, rct.w - cornerRadius)) < cornerRadius;
    }
    return true;
}

out vec4 fragColor;

void main() {
    vec2 xy = FlutterFragCoord().xy;
    vec2 center = resolution * 0.5;

    float dx = origin - pointer;
    float x = container.z - dx;

    float d = xy.x - x;

    // When the fragment is outside of the radius
    if (d > r) {
        fragColor = TRANSPARENT;

        // Adjust the alpha value based on distance outside the radius
        if (inRect(xy, container)) {
            fragColor.a = mix(0.5, 0.0, (d - r) / r);
        }
    }
    // When the fragment is within the transition zone of the radius
    else if (d > 0.0) {
        float theta = asin(d / r);
        float d1 = theta * r;
        float d2 = (PI - theta) * r;
        const float HALF_PI = PI / 2.0;

        vec2 s = vec2(1.0 + (1.0 - sin(HALF_PI + theta)) * 0.1);
        mat3 transform = scale(s, center);
        vec2 uv = project(xy, transform);
        vec2 p1 = vec2(x + d1, uv.y);

        s = vec2(1.1 + sin(HALF_PI + theta) * 0.1);
        transform = scale(s, center);
        uv = project(xy, transform);
        vec2 p2 = vec2(x + d2, uv.y);

        if (inRect(p2, container)) {
            fragColor = texture(image, p2 / resolution);
        } else if (inRect(p1, container)) {
            fragColor = texture(image, p1 / resolution);
            fragColor.rgb *= pow(clamp((r - d) / r, 0.0, 1.0), 0.2);
        } else if (inRect(xy, container)) {
            fragColor = vec4(0.0, 0.0, 0.0, 0.5);
        }
    }
    // When the fragment is inside the radius
    else {
        vec2 s = vec2(1.2);
        mat3 transform = scale(s, center);
        vec2 uv = project(xy, transform);

        vec2 p = vec2(x + abs(d) + PI * r, uv.y);
        if (inRect(p, container)) {
            fragColor = texture(image, p / resolution);
        } else {
            fragColor = texture(image, xy / resolution);
        }
    }
}
