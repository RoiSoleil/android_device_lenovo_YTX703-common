/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "light.msm8952"

#include "Lights.h"

#include <android-base/logging.h>

#include <fstream>

using aidl::android::hardware::light::BrightnessMode;
using aidl::android::hardware::light::FlashMode;
using aidl::android::hardware::light::HwLight;
using aidl::android::hardware::light::HwLightState;
using aidl::android::hardware::light::LightType;

namespace aidl::android::hardware::light {

namespace {

constexpr int32_t kBacklightId = 0;
constexpr int32_t kNotificationId = 1;

constexpr const char* kBacklightPath = "/sys/class/leds/lcd-backlight/brightness";
constexpr const char* kBacklightMaxPath = "/sys/class/leds/lcd-backlight/max_brightness";

constexpr const char* kNotificationBrightnessPath = "/sys/class/leds/green/brightness";
constexpr const char* kNotificationBlinkPath = "/sys/class/leds/green/blink";
constexpr const char* kNotificationPatternPath = "/sys/class/leds/green/led_time";

int rgbToBrightness(int color) {
    color &= 0x00ffffff;
    return ((77 * ((color >> 16) & 0x00ff)) + (150 * ((color >> 8) & 0x00ff)) +
            (29 * (color & 0x00ff))) >>
           8;
}

}  // namespace

Lights::Lights() {
    std::ifstream max(kBacklightMaxPath);
    int value = 0;
    if (max >> value && value > 0) {
        mBacklightMax = value;
    }
}

int Lights::writeInt(const std::string& path, int value) {
    std::ofstream stream(path);
    if (!stream) {
        LOG(ERROR) << "Failed to open " << path;
        return -errno;
    }
    stream << value << std::endl;
    return 0;
}

void Lights::setBacklight(const HwLightState& state) {
    if (state.brightnessMode == BrightnessMode::LOW_PERSISTENCE) {
        // No low-persistence panel support on this device.
        return;
    }

    int brightness = rgbToBrightness(state.color);
    brightness = brightness * mBacklightMax / 255;

    writeInt(kBacklightPath, brightness);
}

void Lights::setNotification(const HwLightState& state) {
    const int alpha = (state.color >> 24) & 0xff;
    const bool blink = state.flashMode == FlashMode::TIMED && state.flashOnMs > 0 &&
                       state.flashOffMs > 0;

    if (blink) {
        const int on = (state.flashOnMs + 999) / 1000;
        const int off = (state.flashOffMs + 999) / 1000;

        std::ofstream pattern(kNotificationPatternPath);
        pattern << "2 " << on << " 2 " << off << std::endl;

        writeInt(kNotificationBlinkPath, 1);
    } else {
        writeInt(kNotificationBlinkPath, 0);
    }

    writeInt(kNotificationBrightnessPath, alpha);
}

ndk::ScopedAStatus Lights::setLightState(int32_t id, const HwLightState& state) {
    std::lock_guard<std::mutex> lock(mLock);

    switch (id) {
        case kBacklightId:
            setBacklight(state);
            return ndk::ScopedAStatus::ok();
        case kNotificationId:
            setNotification(state);
            return ndk::ScopedAStatus::ok();
        default:
            return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
    }
}

ndk::ScopedAStatus Lights::getLights(std::vector<HwLight>* lights) {
    HwLight backlight;
    backlight.id = kBacklightId;
    backlight.ordinal = 0;
    backlight.type = LightType::BACKLIGHT;

    HwLight notification;
    notification.id = kNotificationId;
    notification.ordinal = 0;
    notification.type = LightType::NOTIFICATIONS;

    *lights = {backlight, notification};
    return ndk::ScopedAStatus::ok();
}

}  // namespace aidl::android::hardware::light
