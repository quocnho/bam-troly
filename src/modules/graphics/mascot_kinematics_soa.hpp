#pragma once
#include <array>
#include <algorithm>
#include <cmath>

namespace BamMascot {

enum JointChannel : size_t {
    EarLeft = 0, EarRight, Tail, NameTag, SquashDeform, Count
};

// Data-Oriented Design (DOD): Structure of Arrays (SoA) liền kề 64-byte aligned
struct alignas(64) MascotKinematicsSoA {
    std::array<float, JointChannel::Count> position{};
    std::array<float, JointChannel::Count> velocity{};
    std::array<float, JointChannel::Count> target{};
    std::array<float, JointChannel::Count> stiffness{};
    std::array<float, JointChannel::Count> damping{};

    void initDefaults() noexcept {
        stiffness[EarLeft] = 220.0f; damping[EarLeft] = 15.0f;
        stiffness[EarRight] = 220.0f; damping[EarRight] = 15.0f;
        stiffness[Tail] = 190.0f; damping[Tail] = 12.0f;
        stiffness[NameTag] = 160.0f; damping[NameTag] = 10.0f;
        // Disney Squash Dynamics: Hồi phục độ nhún nhanh nhưng đàn hồi cao
        stiffness[SquashDeform] = 240.0f; damping[SquashDeform] = 16.0f;
        target[SquashDeform] = 0.0f;
    }

    void step(float dt) noexcept {
        const float clampedDt = std::min(dt, 0.05f);
        for (size_t i = 0; i < JointChannel::Count; ++i) {
            float force = -stiffness[i] * (position[i] - target[i]) - damping[i] * velocity[i];
            velocity[i] += force * clampedDt;
            position[i] += velocity[i] * clampedDt;
        }
    }

    void impulse(JointChannel ch, float val) noexcept {
        velocity[ch] += val;
    }
};

} // namespace BamMascot
