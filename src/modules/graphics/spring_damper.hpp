#pragma once
#include <algorithm>

namespace BamMascot {

struct SpringDamper {
    float position{0.0f};
    float velocity{0.0f};
    float target{0.0f};
    float stiffness{180.0f};
    float damping{14.0f};

    void update(float dt) noexcept {
        float clampedDt = std::min(dt, 0.05f);
        float force = -stiffness * (position - target) - damping * velocity;
        velocity += force * clampedDt;
        position += velocity * clampedDt;
    }

    void impulse(float value) noexcept {
        velocity += value;
    }

    void reset(float initialPos = 0.0f) noexcept {
        position = initialPos;
        velocity = 0.0f;
        target = initialPos;
    }
};

} // namespace BamMascot
