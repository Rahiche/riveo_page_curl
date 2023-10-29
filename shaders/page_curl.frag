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

vec2 project(vec2 p, mat3 m) {
    return (inverse(m) * vec3(p, 1.0)).xy;
}

struct Paint {
    vec4 color;
    bool stroke;
    float strokeWidth;
    int blendMode;
};

struct Context {
    vec4 color;
    vec2 p;
    vec2 resolution;
};


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

    if (d > r) {
        fragColor = TRANSPARENT;
        if (inRect(xy, container)) {
            fragColor.a = mix(0.5, 0.0, (d-r)/r);
        }
    }

    else
    if (d > 0.0) {
        float theta = asin(d / r);
        float d1 = theta * r;
        float d2 = (3.14159265 - theta) * r;

        vec2 s = vec2(1.0 + (1.0 - sin(3.14159265/2.0 + theta)) * 0.1);
        mat3 transform = scale(s, center);
        vec2 uv = project(xy, transform);
        vec2 p1 = vec2(x + d1, uv.y);

        s = vec2(1.1 + sin(3.14159265/2.0 + theta) * 0.1);
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
    else {
        vec2 s = vec2(1.2);
        mat3 transform = scale(s, center);
        vec2 uv = project(xy, transform);

        vec2 p = vec2(x + abs(d) + 3.14159265 * r, uv.y);
        if (inRect(p, container)) {
            fragColor = texture(image, p / resolution);
        } else {
            fragColor = texture(image, xy / resolution);
        }
    }

}
