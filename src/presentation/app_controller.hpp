#pragma once
#include <QObject>
#include <QString>
#include <QPoint>
#include <memory>
#include "workflow/agent_workflow.hpp"
#include "modules/storage/db_manager.hpp"

class AppController : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isGenerating READ isGenerating NOTIFY isGeneratingChanged)
    Q_PROPERTY(bool isExpanded READ isExpanded WRITE setExpanded NOTIFY isExpandedChanged)

    Q_PROPERTY(bool isDarkTheme READ isDarkTheme NOTIFY themeChanged)
    Q_PROPERTY(QObject* physics READ physics CONSTANT)

public:
    explicit AppController(QObject *parent = nullptr);
    ~AppController() override;

    bool isGenerating() const { return m_isGenerating; }
    bool isExpanded() const { return m_isExpanded; }
    bool isDarkTheme() const { return m_isDarkTheme; }
    QObject* physics() const;
    void setExpanded(bool expanded);

    Q_INVOKABLE void sendMessage(const QString &text);
    Q_INVOKABLE void stopGeneration();
    Q_INVOKABLE void clearHistory();
    Q_INVOKABLE void copyToClipboard(const QString &text);
    Q_INVOKABLE void savePosition(int x, int y);
    Q_INVOKABLE void saveDisplayMetrics(double scale, double dpi);
    Q_INVOKABLE QPoint getSavedPosition(int defaultX, int defaultY);
    Q_INVOKABLE QPoint getCursorPos();
    Q_INVOKABLE void toggleDesktopTheme();
    Q_INVOKABLE void quitApp();

signals:
    void isGeneratingChanged();
    void isExpandedChanged();
    void themeChanged();
    void tokenReceived(const QString &token);
    void messageCompleted(const QString &fullReply);

private:
    bool m_isGenerating{false};
    bool m_isExpanded{false};
    bool m_isDarkTheme{true};
    std::shared_ptr<DbManager> m_db;
    std::unique_ptr<AgentWorkflow> m_workflow;
    class MascotPhysics *m_physics{nullptr};
};
