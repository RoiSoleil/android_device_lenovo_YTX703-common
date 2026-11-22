/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

#include <aidl/android/hardware/light/BnLights.h>
#include <aidl/android/hardware/light/HwLight.h>
#include <aidl/android/hardware/light/HwLightState.h>

#include <mutex>

namespace aidl::android::hardware::light {

class Lights : public BnLights {
  public:
    Lights();

    ndk::ScopedAStatus setLightState(int32_t id, const HwLightState& state) override;
    ndk::ScopedAStatus getLights(std::vector<HwLight>* lights) override;

  private:
    void setBacklight(const HwLightState& state);
    void setNotification(const HwLightState& state);

    int writeInt(const std::string& path, int value);

    std::mutex mLock;
    int mBacklightMax = 255;
};

}  // namespace aidl::android::hardware::light
