#include "app_controller.hpp"
#include "modules/ai/llama_engine.hpp"
#include "modules/graphics/mascot_physics.hpp"
#include "plugins/builtins/memory_tool.cpp"

#include <QProcess>
#include <QFile>

AppController::AppController(QObject *parent)
    : QObject(parent),
      m_db(std::make_shared<DbManager>()),
      m_physics(new MascotPhysics(this)) {
    m_db->initDatabase();

    // Reset vị trí về mặc định nếu reboot hệ điều hành (boot_id mới)
    QFile bootFile("/proc/sys/kernel/random/boot_id");
    if (bootFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString currentBoot = QString::fromUtf8(bootFile.readAll()).trimmed();
        if (!currentBoot.isEmpty() && m_db->getSetting("last_boot_id", "") != currentBoot) {
            m_db->setSetting("pos_x", ""); m_db->setSetting("pos_y", "");
            m_db->setSetting("last_boot_id", currentBoot);
        }
    }

    QString savedTheme = m_db->getSetting("app_theme", "dark");
    m_isDarkTheme = (savedTheme != "light");

    auto ai = std::make_shared<LlamaEngine>();
    auto tools = std::make_shared<ToolRegistry>();
    tools->registerTool(std::make_shared<MemoryTool>());

    m_workflow = std::make_unique<AgentWorkflow>(ai, m_db, tools);

    connect(m_workflow.get(), &AgentWorkflow::tokenStreamed, this, [this](const QString &token) {
        emit tokenReceived(token);
    });

    connect(m_workflow.get(), &AgentWorkflow::workflowCompleted, this, [this](const QString &reply) {
        m_isGenerating = false;
        emit isGeneratingChanged();
        emit messageCompleted(reply);
    });
}

AppController::~AppController() = default;
QObject* AppController::physics() const { return m_physics; }

void AppController::setExpanded(bool expanded) {
    if (m_isExpanded != expanded) { m_isExpanded = expanded; emit isExpandedChanged(); }
}

void AppController::sendMessage(const QString &text) {
    if (text.trimmed().isEmpty() || m_isGenerating) return;
    m_isGenerating = true; emit isGeneratingChanged();
    m_workflow->processUserMessage(text);
}

void AppController::stopGeneration() {
    if (m_isGenerating) { m_workflow->stop(); m_isGenerating = false; emit isGeneratingChanged(); }
}

#include <QGuiApplication>
#include <QClipboard>
#include <QCursor>
#include <QCoreApplication>

void AppController::clearHistory() { m_db->clearHistory(); }
void AppController::copyToClipboard(const QString &text) {
    if (auto clip = QGuiApplication::clipboard()) clip->setText(text);
}
void AppController::savePosition(int x, int y) {
    m_db->setSetting("pos_x", QString::number(x));
    m_db->setSetting("pos_y", QString::number(y));
}
void AppController::saveDisplayMetrics(double scale, double dpi) {
    m_db->setSetting("display_scale", QString::number(scale));
    m_db->setSetting("display_dpi", QString::number(dpi));
}
QPoint AppController::getSavedPosition(int defaultX, int defaultY) {
    QString sx = m_db->getSetting("pos_x", "");
    QString sy = m_db->getSetting("pos_y", "");
    bool okX = false, okY = false;
    int x = sx.toInt(&okX); int y = sy.toInt(&okY);
    return QPoint(okX ? x : defaultX, okY ? y : defaultY);
}
QPoint AppController::getCursorPos() { return QCursor::pos(); }
void AppController::quitApp() {
    m_db->setSetting("pos_x", "");
    m_db->setSetting("pos_y", "");
    QCoreApplication::quit();
}

void AppController::toggleDesktopTheme() {
    m_isDarkTheme = !m_isDarkTheme;
    m_db->setSetting("app_theme", m_isDarkTheme ? "dark" : "light");
    emit themeChanged();
}
