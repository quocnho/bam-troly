cmake_minimum_required(VERSION 3.24)
project(bam-troly VERSION 26.01.02 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick QuickControls2)
find_package(SQLite3 REQUIRED)

qt_add_executable(bam-troly
    src/main.cpp
    src/presentation/app_controller.cpp
    src/presentation/app_controller.hpp
    src/workflow/agent_workflow.cpp
    src/workflow/agent_workflow.hpp
    src/plugins/tool_registry.cpp
    src/plugins/tool_registry.hpp
    src/modules/storage/db_manager.cpp
    src/modules/storage/db_manager.hpp
    src/modules/graphics/mascot_physics.cpp
    src/modules/graphics/mascot_physics.hpp
    src/modules/graphics/mascot_kinematics_soa.hpp
    src/modules/ai/ai_provider.hpp
    src/modules/ai/llama_engine.cpp
    src/modules/ai/llama_engine.hpp
)


qt_add_qml_module(bam-troly
    URI BamTroly
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/mascot/DogMascotHost.qml
        qml/mascot/parts/DogEyes.qml
        qml/mascot/parts/DogEars.qml
        qml/mascot/parts/DogMouth.qml
        qml/mascot/parts/DogTail.qml
        qml/mascot/parts/DogTorso.qml
        qml/mascot/parts/DogFrontPaws.qml
        qml/mascot/parts/DogNameTag.qml
        qml/mascot/parts/DogHeadAssembly.qml
        qml/mascot/parts/DogSideWalk.qml
        qml/mascot/behaviors/DogRigMascot.qml
        qml/mascot/behaviors/BarkAnimationFlow.qml
        qml/mascot/behaviors/JumpBounceAnimationFlow.qml
        qml/mascot/behaviors/HoverGreetingFlow.qml
        qml/mascot/behaviors/PlayfulBehavior.qml
        qml/mascot/behaviors/MascotInteractionController.qml
        qml/mascot/behaviors/DogEarBehavior.qml
        qml/mascot/behaviors/SleepDreamBubbleFlow.qml
        qml/mascot/behaviors/IntroRunner.qml
        qml/mascot/behaviors/MascotWindowTracker.qml
        qml/chat/ChatWindow.qml
        qml/chat/ChatPanel.qml
        qml/chat/ChatHeader.qml
        qml/chat/MessageList.qml
        qml/chat/MessageBubble.qml
        qml/chat/CodeBlockView.qml
        qml/chat/PromptInput.qml
        qml/chat/ChatTooltip.qml
        qml/chat/CopyButton.qml
        qml/dialogs/ConfirmDialog.qml
        qml/common/StatusIndicator.qml
        qml/common/HourlyClockPopup.qml
        qml/mascot/MascotActionBar.qml
        qml/mascot/MascotActionButton.qml
        qml/mascot/behaviors/MascotFollowMover.qml
    RESOURCES
        assets/images/dog_bark.png
        assets/images/dog_run.png
        assets/images/dog_sit.png
        assets/images/dog_lie.png
        assets/images/dog_sleep.png
        assets/images/dog_walk_side.png
)

target_include_directories(bam-troly PRIVATE src)

find_package(PkgConfig QUIET)
if (PKG_CONFIG_FOUND)
    pkg_check_modules(LLAMA QUIET IMPORTED_TARGET llama)
endif()

if (TARGET PkgConfig::LLAMA)
    target_compile_definitions(bam-troly PRIVATE BAM_ENABLE_LLAMA=1)
    target_link_libraries(bam-troly PRIVATE PkgConfig::LLAMA)
elseif (LLAMA_FOUND)
    target_compile_definitions(bam-troly PRIVATE BAM_ENABLE_LLAMA=1)
    target_include_directories(bam-troly PRIVATE ${LLAMA_INCLUDE_DIRS})
    target_link_directories(bam-troly PRIVATE ${LLAMA_LIBRARY_DIRS})
    target_link_libraries(bam-troly PRIVATE ${LLAMA_LIBRARIES})
else()
    find_package(llama QUIET)
    if (TARGET llama OR TARGET llama::llama)
        target_compile_definitions(bam-troly PRIVATE BAM_ENABLE_LLAMA=1)
        target_link_libraries(bam-troly PRIVATE llama)
    endif()
endif()

target_link_libraries(bam-troly PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
    SQLite3::SQLite3
)

