#include "mascot_physics.hpp"

MascotPhysics::MascotPhysics(QObject *parent)
    : QObject(parent) {
    m_soa.initDefaults();
}

void MascotPhysics::applyWindowVelocity(float vx, float vy) {
    float clampedVx = std::clamp(vx, -80.0f, 80.0f);
    float clampedVy = std::clamp(vy, -80.0f, 80.0f);
    m_soa.impulse(BamMascot::EarLeft, -clampedVx * 0.45f - clampedVy * 0.2f);
    m_soa.impulse(BamMascot::EarRight, -clampedVx * 0.45f + clampedVy * 0.2f);
    m_soa.impulse(BamMascot::Tail, clampedVx * 0.65f);
    m_soa.impulse(BamMascot::NameTag, -clampedVx * 0.85f);
    // Quán tính di chuyển dọc: làm nảy nhẹ thân mình theo Disney Squash
    m_soa.impulse(BamMascot::SquashDeform, -clampedVy * 0.008f);
    emit dynamicsChanged();
}

void MascotPhysics::triggerImpact(float intensity) {
    float cl = std::clamp(intensity, -1.0f, 1.0f);
    m_soa.impulse(BamMascot::SquashDeform, cl * 0.45f);
    emit dynamicsChanged();
}

void MascotPhysics::step(float dtSec) {
    m_soa.step(dtSec);
    emit dynamicsChanged();
}
