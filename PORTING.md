# Portage LineageOS 23.2 — état des lieux

Ce document décrit le portage du device tree Lenovo Yoga Tab 3 Plus (YTX703F/L)
de **lineage-18.1 (Android 11)** vers **lineage-23.2 (Android 16)**.

Branche de travail : `wip/lineage-23.2`.

## Résumé

| Élément | 18.1 | 23.2 (état) |
|---|---|---|
| Kernel | 3.10.84 | 3.10.84 + backport eBPF à appliquer |
| Treble | non (`/system/vendor`) | non, conservé (voir G4) |
| SEPolicy | `device/qcom/sepolicy-legacy` | in-tree uniquement, permissive |
| HALs | HIDL 1.0 → 6.0 | HIDL 7.0/x + AIDL pour les HALs supprimés |
| Build files | legacy | modernisés (voir diff) |

Ce portage est **inspiré d'un précédent réel** : le LG G4 (msm8992, kernel 3.10,
non-Treble) maintenu jusqu'à Android 16 par aoleary :

- https://github.com/aoleary/device_lge_g4-common (branche `16`)
- https://github.com/aoleary/G4-Titan-Kernel (branches `titan_bpf2`, `titan_16`)
- https://github.com/aoleary/hardware_qcom-caf_msm8992 (branche `lineage-23.0`)

## Ce qui a été fait dans cette branche

### `BoardConfigCommon.mk`
- Ajout `TARGET_USES_QCOM_BSP`, `TARGET_USES_GRALLOC1`, `TARGET_USES_HWC2`.
- Kernel : build GCC legacy (`TARGET_KERNEL_CLANG_COMPILE := false`,
  `TARGET_KERNEL_NEW_GCC_COMPILE := true`,
  `TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-`),
  `NEED_KERNEL_MODULE_SYSTEM := true` (pas de modules depuis `/vendor` en 3.10).
- `OVERRIDE_TARGET_FLATTEN_APEX := true` : pas de partition `/vendor`, les APEX
  doivent être aplatis dans `/system`.
- Suppression des variables mortes en 23.2 : `TARGET_USE_SDCLANG`,
  `WITH_DEXPREOPT*`, `TARGET_PROVIDES_KEYMASTER`,
  `TARGET_KEYMASTER_WAIT_FOR_QSEE`, `BOARD_USES_LINEAGE_HARDWARE`,
  `BOARD_HARDWARE_CLASS`, `TARGET_USES_MEDIA_EXTENSIONS`, TWRP.
- SEPolicy : plus d'include `device/qcom/sepolicy-legacy` (le repo n'existe plus
  au-delà de lineage-16.0), `BOARD_VENDOR_SEPOLICY_DIRS` + `SELINUX_IGNORE_NEVERALLOWS`.
- `TARGET_RECOVERY_FSTAB` explicite, `BOARD_AVB_ENABLE := false`.
- Namespaces Soong `hardware/qcom-caf/msm8952/{audio,display,media}`.
- Vintf : `DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE` (l'ancienne
  compatibility matrix « legacy » n'est plus valide).

### `device-common.mk`
- Audio migré HIDL 6.0 → 7.0, `soundtrigger` 2.0 → 2.2,
  `audio.a2dp.default` → `audio.bluetooth.default`.
- `Snap` → `Aperture`, `camera.device@3.2` → `camera.device@3.4`.
- `keymaster@3.0` + `gatekeeper@1.0` → `android.hardware.security.keymint-service`
  + `com.android.hardware.gatekeeper.nonsecure`.
- `vibrator@1.0` supprimé (la tablette n'a pas de moteur de vibration).
- `light@2.0` → `android.hardware.light-service.msm8952` : nouvelle
  implémentation AIDL (`hardware/liblight/aidl/`), backlight LCD + LED verte
  de notifications, mêmes chemins sysfs que l'ancien HAL HIDL.
- `health@2.1` → `android.hardware.health-service.qti`.
- `wifi@1.0-service` → `android.hardware.wifi-service` (AIDL).
- `usb@1.0` → `android.hardware.usb@1.3-service.basic`.
- `configstore@1.1` → `disable_configstore`.
- Suppression : `keystore.msm8952`, `fs_config_files`, `libextmedia_jni`.
- LiveDisplay et Trust HAL commentés (interfaces supprimées).
- Symlinks WCNSS : `BOARD_VENDOR_EXTRA_SYMLINKS` (disparu) remplacé par des
  modules Soong `install_symlink` dans `Android.bp`.

### Divers
- `manifest.xml` : `target-level="5"`, versions HIDL alignées, HALs supprimés
  retirés (keymaster, gatekeeper, light, vibrator) car fournis en AIDL avec
  leurs propres fragments vintf.
- `framework_compatibility_matrix.xml` : nouvelle matrice framework.
- `compatibility_matrix.xml` supprimé.
- `vendor.prop` ajouté.

## Travail restant — par ordre de priorité

### 1. Kernel : backport eBPF (bloquant)

**État : backport appliqué et kernel compilé** — branche
`wip/android16-bpf` de `RoiSoleil/android_kernel_lenovo_msm8976`
(`Image.gz-dtb` 30 Mo, 185 symboles eBPF, `CONFIG_BPF_SYSCALL=y`,
`CONFIG_CGROUP_BPF=y`, `CONFIG_MEMCG=y`).

- les ~836 commits de la série ont été appliqués avec `cherry-pick -x`
  (2 conflits résolus, 1 commit cgroup sauté)
- `scripts/gcc-wrapper.py` porté en Python 3 (le toolchain GCC 4.9 prebuilt est
  un wrapper Python 2)
- defconfig : `CONFIG_BPF*`, `CONFIG_MEMCG=y`, désactivation de
  `CONFIG_GET_HARDWARE_INFO` (conflit camera) et de BFQ (API cgroup obsolète)
- `kernel/bpf/core.c` : include de `<linux/module.h>`
- build hôte : `HOSTCFLAGS="-fcommon -O2"` (dtc vs GCC 10+)
- warnings non bloquantes (le wrapper GCC Android les transformait en erreurs)
- `sysfs_get_dirent()` du mdss adapté à l'API kernfs
- callback cgroup HMP migrés vers l'API `css`
- deuxième driver Synaptics désactivé (collision de symboles)

Voir `BUILD_NOTES.md` et `BPF_BACKPORT.md` dans le repo kernel.

Reste à faire côté kernel : activer `CONFIG_MODULES` pour avoir le JIT eBPF
(`CONFIG_BPF_JIT`, `CONFIG_BPF_JIT_ALWAYS_ON`) ; l'interpréteur compile et
fonctionne en attendant.

Base de référence : https://github.com/aoleary/kernel_leeco_msm8976-bpf
(même SoC msm8976, kernel 3.10.108, ~836 commits de backport).

Procédure prévue :

```bash
# 1. Cloner le kernel du device (fork : RoiSoleil/android_kernel_lenovo_msm8976)
git clone https://github.com/RoiSoleil/android_kernel_lenovo_msm8976
cd android_kernel_lenovo_msm8976
git checkout -b lineage-23.2

# 2. Récupérer la série de backport
git remote add bpf https://github.com/aoleary/kernel_leeco_msm8976-bpf
git fetch --depth=900 bpf master

# 3. Identifier le premier commit de la série
#    (premier commit touchant kernel/bpf, ~eeb7a46702 "net: filter: split filter.c into two files")
git log --reverse --format='%H %s' bpf/master -- kernel/bpf | head -1

# 4. Cherry-pick de la série
git cherry-pick -x <premier_commit>^..bpf/master
#    Résoudre les conflits (attendu : msm8976 dts, defconfig, drivers msm,
#    net/ipv4, fs) puis :
git am --continue / git cherry-pick --continue

# 5. Config minimal pour Android 16
#    CONFIG_BPF_SYSCALL=y, CONFIG_BPF_JIT=y, CONFIG_BPF_JIT_ALWAYS_ON=y,
#    CONFIG_CGROUP_BPF=y, CONFIG_NET_CLS_BPF=y, CONFIG_NET_ACT_BPF=y,
#    CONFIG_HAVE_EBPF_JIT=y, CONFIG_BPF_EVENTS=y, CONFIG_KPROBE_EVENTS=y,
#    CONFIG_FTRACE_SYSCALLS=y, CONFIG_MEMFD_CREATE (si backporté),
#    CONFIG_ANDROID_BINDER_IPC=y (binder legacy : pas de binderfs requis).
```

Points d'attention :
- Le kernel Lenovo est en 3.10.84, la base LeEco en 3.10.108 : cherry-pick avec
  `-x` et résolution au cas par cas, ne pas tenter un merge global.
- Les commits `s2:`/`arm: dts:` de la série sont spécifiques au LeEco et doivent
  être **ignorés** (garder les dts Lenovo).
- Le JIT eBPF 32 bits (`8b9a09fb arm: eBPF JIT compiler`) est nécessaire pour
  le userspace 32 bits (nos blobs sont 32 bits).

### 2. HALs AIDL à écrire (dans le device tree)

- `android.hardware.light-service.msm8952` : **fait** (voir `hardware/liblight/aidl/`).
- `android.hardware.vibrator-service.*` : **non nécessaire** (pas de vibreur).
- Sensors : `android.hardware.sensors-service.multihal` (AOSP) charge
  `sensors.msm8952.so` via `_hals.conf` ; notre `hardware/sensors/` in-tree
  (HIDL 1.0) doit être remplacé par le multihal AOSP + le blob.
- Camera : conserver `camera.device@3.4` + `camera.provider@2.4-legacy` +
  `camera.msm8952` (QCamera2 in-tree). C'est ce que fait le G4.
- KeyMint : vérifier que les blobs `libkeymaster*` de la ROM stock sont
  compatibles avec `android.hardware.security.keymint-service` ; sinon garder
  un keymaster HIDL 4.0 si le blob le permet (à tester).

### 3. HALs Qualcomm CAF (msm8952)

Le repo `hardware/qcom-caf/msm8952` n'existe plus dans l'org LineageOS aux
branches récentes. Deux options :
- réutiliser/forker les HALs msm8953 maintenus (XOS-16.2) et adapter les noms
  de modules (`gralloc.msm8953` → `msm8952`, etc.) ;
- forward-porter le fork `aoleary/hardware_qcom-caf_msm8992` (lineage-23.0),
  structure identique (audio/display/media), en remplaçant msm8992 par msm8952.

C'est le plus gros morceau restant côté userspace.

### 4. SEPolicy

Le kernel démarre en permissive (`androidboot.selinux=permissive`) donc le
bring-up peut se faire sans policy complète. Ensuite : compléter les `.te`
in-tree, puis passer en enforcing.

### 5. Blobs

`extract-files.sh` fonctionne toujours, mais il faut :
- vérifier que les blobs 32 bits se chargent avec les VNDK modernes ;
- ajouter les shims nécessaires (`TARGET_LD_SHIM_LIBS`), comme le fait le G4.

## Build

```bash
# Source LineageOS 23.2 (~250 Go libres nécessaires sur ext4)
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs
repo sync -c -j8 --force-sync --no-clone-bundle --no-tags

# Device tree
mkdir -p device/lenovo
git clone -b wip/lineage-23.2 https://github.com/RoiSoleil/android_device_lenovo_YTX703-common \
    device/lenovo/YTX703-common

# Kernel (backport eBPF déjà appliqué et compilé)
git clone -b wip/android16-bpf https://github.com/RoiSoleil/android_kernel_lenovo_msm8976 \
    kernel/lenovo/msm8976

# Blobs
cd device/lenovo/YTX703-common
./extract-files.sh <chemin_vers_dump_stock>

# Build
source build/envsetup.sh
lunch lineage_YTX703F-userdebug
mka bacon -j$(nproc)
```

Avec 74 Go libres sur `/`, le sync + build complet **ne passe pas** : prévoir
un disque ext4 de 250–300 Go (le NTFS ne fonctionne pas : symlinks/permissions).

## Références utiles

- Template 23.2 non-Treble 3.10 : `aoleary/device_lge_g4-common@16`
- Template msm8953 moderne : `LineageOS/android_device_xiaomi_msm8953-common@lineage-21`
- Template msm8953 23.2 (Treble, pour les HALs) : `LineageOS/android_device_xiaomi_laurel_sprout@lineage-23.2`
- HALs CAF msm8992 23.0 : `aoleary/hardware_qcom-caf_msm8992@lineage-23.0`
- HALs CAF msm8953 maintenus : `halogenOS/android_hardware_qcom-caf_msm8953_{display,audio,media}@XOS-16.2`
