#
# Copyright (C) 2017-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from the proprietary version
$(call inherit-product-if-exists, vendor/lenovo/YTX703-common/YTX703-common-vendor.mk)

DEVICE_PATH := device/lenovo/YTX703-common

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlay

# Screen density
PRODUCT_AAPT_CONFIG := normal large xlarge
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# Needed by vendor/lineage/bootanimation
TARGET_SCREEN_WIDTH  := 2560
TARGET_SCREEN_HEIGHT := 1600

# Device characteristics
PRODUCT_CHARACTERISTICS := tablet

$(call inherit-product, $(DEVICE_PATH)/configs/memconfig/phone-xxhdpi-3072-dalvik-heap.mk)

#
# PRODUCT_PACKAGES rules
#

# ANT+
PRODUCT_PACKAGES += \
    AntHalService \
    com.dsi.ant.antradio_library \
    libantradio

# APEX
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/ld.config.txt:$(TARGET_COPY_OUT_SYSTEM)/etc/swcodec/ld.config.txt

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@7.0 \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0 \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.soundtrigger@2.2-impl \
    audio.bluetooth.default \
    audio.primary.msm8952 \
    audio.r_submix.default \
    audio.usb.default \
    libaudio-resampler \
    libaudioroute \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcomvoiceprocessingdescriptors \
    libtinyalsa \
    libtinycompress \
    tinymix

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service \
    android.hardware.bluetooth.audio@2.1-impl \
    android.hardware.bluetooth.audio-impl \
    libbt-vendor

# HW crypto
PRODUCT_PACKAGES += \
    vendor.qti.hardware.cryptfshw@1.0-service-qti.qsee

# Camera
PRODUCT_PACKAGES += \
    Aperture \
    camera.device@3.4-impl \
    camera.msm8952 \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    android.hardware.camera.provider@2.4-legacy \
    libmm-qcamera

# Component overrides
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/component-overrides.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sysconfig/component-overrides.xml

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.memtrack@1.0-impl \
    copybit.msm8952 \
    gralloc.msm8952 \
    hwcomposer.msm8952 \
    memtrack.msm8952 \
    liboverlay \
    libqdutils \
    libqservice

# GPS
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    gps.msm8952 \
    libcurl \
    libgnss \
    libgnsspps

# IPv6
PRODUCT_PACKAGES += \
    ebtables \
    ethertypes \
    libebtc

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.msm8952

# OMX
PRODUCT_PACKAGES += \
    libc2dcolorconvert \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxSwVencHevc \
    libOmxVdec \
    libOmxVenc \
    libminijail \
    libstagefrighthw

# Qualcomm dependencies
PRODUCT_PACKAGES += \
    libtinyxml \
    libxml2

# Recovery
PRODUCT_PACKAGES += \
    init.recovery.qcom.rc

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.multihal

# Seccomp policy
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/seccomp_policy/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# Tethering
PRODUCT_PACKAGES += \
    TetheringConfigOverlay

# TimeKeep
PRODUCT_PACKAGES += \
    timekeep \
    TimeKeep

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service \
    thermal.msm8952

# Wifi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    libqsap_sdk \
    libQWiFiSoftApCfg \
    libwifi-hal-qcom \
    libwpa_client \
    libwcnss_qmi \
    WCNSS_qcom_cfg_ini_symlink \
    WCNSS_qcom_wlan_nv_bin_symlink \
    WCNSS_wlan_dictionary_dat_symlink \
    WifiOverlay \
    wcnss_service \
    wificond \
    wpa_supplicant \
    wpa_supplicant.conf

# HIDL HAL list
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

# Configstore
PRODUCT_PACKAGES += \
    disable_configstore

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.0 \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0 \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.soundtrigger@2.2-impl

# Netutils
PRODUCT_PACKAGES += \
    netutils-wrapper-1.0 \
    libandroid_net

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl

# Usb HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.basic

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service-qti \
    vendor.qti.hardware.perf@2.0

# Health HAL
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti

# Media
PRODUCT_PACKAGES += \
    android.hardware.media.omx@1.0-impl \
    android.hardware.media.omx@1.0-service

# Keymaster / Gatekeeper (KeyMint AIDL, replaces removed keymaster@3.0)
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service \
    com.android.hardware.gatekeeper.nonsecure

# Vibrator: the Yoga Tab 3 Plus has no vibration motor, so no vibrator HAL
# is shipped. (vibrator@1.0 was removed from AOSP anyway.)
# Lineage Health
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

# LiveDisplay
# TODO(23.2): livedisplay@2.0 was dropped, needs the AIDL LineageDisplay HAL
#PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay@2.0-service-sysfs

# Trust HAL (removed in 23.x, trust is now part of the Lineage SDK)
#PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service

# Dummy hidl lib for oreo blobs
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.base@1.0.vendor \
    libhidltransport \
    libhidltransport.vendor \
    libhwbinder \
    libhwbinder.vendor

#
# PRODUCT_COPY_FILES rules
#

# Device-specific permissions
PRODUCT_COPY_FILES += $(foreach permission, $(wildcard $(DEVICE_PATH)/configs/permissions/*), \
    $(permission):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/permissions/, $(notdir $(permission))) )

# Standard permissions
PRODUCT_COPY_FILES += \
    external/ant-wireless/antradio-library/com.dsi.ant.antradio_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.dsi.ant.antradio_library.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_0_3.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Device-specific audio configs
PRODUCT_COPY_FILES += $(foreach audio_config, $(wildcard $(DEVICE_PATH)/configs/audio/*), \
    $(audio_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/, $(notdir $(audio_config))) )

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Standard audio configs
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# IPC router config
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Device-specific codec configuration
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/media/media_codecs_8956_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(DEVICE_PATH)/configs/media/media_codecs_performance_8956_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(DEVICE_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Standard (software) codec configuration
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml

# Sensors configuration files
PRODUCT_COPY_FILES += $(foreach sensor_config, $(wildcard $(DEVICE_PATH)/configs/sensors/*), \
    $(sensor_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/sensors/, $(notdir $(sensor_config))) )

# Wi-Fi and WCNSS configuration files
PRODUCT_COPY_FILES += $(foreach wifi_config, $(wildcard $(DEVICE_PATH)/configs/wifi/*), \
    $(wifi_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/wifi/, $(notdir $(wifi_config))) ) \
    $(DEVICE_PATH)/configs/hostapd_default.conf:$(TARGET_COPY_OUT_VENDOR)/etc/hostapd/hostapd_default.conf

# Cellular data configuration files
PRODUCT_COPY_FILES += $(foreach data_config, $(wildcard $(DEVICE_PATH)/configs/data/*), \
    $(data_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/data/, $(notdir $(data_config))) )

# GPS configuration files
PRODUCT_COPY_FILES += $(foreach gps_config, $(wildcard $(DEVICE_PATH)/configs/gps/*), \
    $(gps_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/, $(notdir $(gps_config))) )

# Thermal engine configuration file
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf

# Profiles for perfd
PRODUCT_COPY_FILES += $(foreach perf_profile, $(wildcard $(DEVICE_PATH)/configs/perf-profiles/*), \
    $(perf_profile):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/perf/, $(notdir $(perf_profile))) )

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/perfd/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml \
    $(DEVICE_PATH)/configs/perfd/perfboostsconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/perf/perfboostsconfig.xml \
    $(DEVICE_PATH)/configs/perfd/targetconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/perf/targetconfig.xml \
    $(DEVICE_PATH)/configs/perfd/targetresourceconfigs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/perf/targetresourceconfigs.xml

# Configs for msm_irqbalance
PRODUCT_COPY_FILES += $(foreach irqbalance_config, $(wildcard $(DEVICE_PATH)/configs/irqbalance/*), \
    $(irqbalance_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/, $(notdir $(irqbalance_config))) )

# Fstab
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    $(DEVICE_PATH)/configs/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# Vendor-provided service definitions (executed by init scripts)
PRODUCT_COPY_FILES += \
    $(foreach service, $(wildcard $(DEVICE_PATH)/configs/init/*.rc), \
    $(service):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/init/, $(notdir $(service))) ) \
    $(foreach service, $(wildcard $(DEVICE_PATH)/configs/init/hw/*), \
    $(service):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/init/hw/, $(notdir $(service))) )

#
# System partition symlinks.
#
# 18.1 used BOARD_VENDOR_EXTRA_SYMLINKS, which is processed by
# vendor/lineage/build/tasks/target_symlinks.mk and no longer exists in 23.2.
# These links are now created by the install_symlink modules in Android.bp.
#
#   /vendor/firmware/wlan/prima/{WCNSS_qcom_cfg.ini,WCNSS_wlan_dictionary.dat,
#                                WCNSS_qcom_wlan_nv.bin} -> /vendor/etc/wifi/...
#   /vendor/etc/acdbdata -> etc/a            (hacked libacdbloader)
#   /vendor/etc/sensors  -> snsc             (sensors.qcom)
#
TARGET_DISABLE_WCNSS_CONFIG_COPY := true

#
# VNDK blobs for the Oreo-era proprietary libraries
#
PRODUCT_COPY_FILES += \
    prebuilts/vndk/v27/arm64/arch-arm64-armv8-a/shared/vndk-core/android.hardware.gnss@1.0.so:system/lib64/android.hardware.gnss@1.0-v27.so \
    prebuilts/vndk/v28/arm64/arch-arm64-armv8-a/shared/vndk-core/libprotobuf-cpp-full.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libprotobuf-cpp-full-v28.so \
    prebuilts/vndk/v28/arm/arch-arm-armv7-a-neon/shared/vndk-core/libprotobuf-cpp-lite.so:$(TARGET_COPY_OUT_VENDOR)/lib/libprotobuf-cpp-lite-v28.so
