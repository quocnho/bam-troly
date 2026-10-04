#pragma once
#include <QObject>
#include "mascot_kinematics_soa.hpp"

class MascotPhysics : public QObject {
    Q_OBJECT
    Q_PROPERTY(float earAngleL READ earAngleL NOTIFY dynamicsChanged)
    Q_PROPERTY(float earAngleR READ earAngleR NOTIFY dynamicsChanged)
    Q_PROPERTY(float tailAngle READ tailAngle NOTIFY dynamicsChanged)
    Q_PROPERTY(float nameTagAngle READ nameTagAngle NOTIFY dynamicsChanged)
    Q_PROPERTY(float squashX READ squashX NOTIFY dynamicsChanged)
    Q_PROPERTY(float squashY READ squashY NOTIFY dynamicsChanged)

public:
    explicit MascotPhysics(QObject *parent = nullptr);

    float earAngleL() const noexcept { return m_soa.position[BamMascot::EarLeft]; }
    float earAngleR() const noexcept { return m_soa.position[BamMascot::EarRight]; }
    float tailAngle() const noexcept { return m_soa.position[BamMascot::Tail]; }
    float nameTagAngle() const noexcept { return m_soa.position[BamMascot::NameTag]; }

    // Disney Volume Conservation: Sx * Sy = 1.0 (Sx = 1 / sqrt(Sy))
    float squashY() const noexcept {
        return std::clamp(1.0f + m_soa.position[BamMascot::SquashDeform], 0.65f, 1.45f);
    }
    float squashX() const noexcept {
        float sy = squashY();
        return std::clamp(1.0f / std::sqrt(sy), 0.75f, 1.35f);
    }

    Q_INVOKABLE void applyWindowVelocity(float vx, float vy);
    Q_INVOKABLE void step(float dtSec = 0.016f);
    Q_INVOKABLE void triggerImpact(float intensity);

signals:
    void dynamicsChanged();

private:
    BamMascot::MascotKinematicsSoA m_soa;
};
