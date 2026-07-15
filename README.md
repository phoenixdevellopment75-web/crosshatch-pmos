<div align="center">

<img src="https://postmarketos.org/static/img/logo/postmarketos-logo.svg" width="120" alt="postmarketOS logo"/>

# postmarketOS for Google Pixel 3 XL

**Cloud-built • One-click flash • Mainline Linux kernel**

[![Build postmarketOS](https://github.com/phoenixdevellopment75-web/crosshatch-pmos/actions/workflows/build-pmos.yml/badge.svg)](https://github.com/phoenixdevellopment75-web/crosshatch-pmos/actions/workflows/build-pmos.yml)
![Device](https://img.shields.io/badge/Device-Pixel%203%20XL-4285F4?logo=google&logoColor=white)
![Kernel](https://img.shields.io/badge/Kernel-Linux%205.3%20Mainline-FCC624?logo=linux&logoColor=black)
![pmaports](https://img.shields.io/badge/pmaports-v25.12-00b4d8)
![UI](https://img.shields.io/badge/UI-Plasma%20Mobile-1d99f3?logo=kde&logoColor=white)
![Status](https://img.shields.io/badge/Status-Experimental-orange)

Build a full mainline Linux system image for the Google Pixel 3 XL (crosshatch) — **entirely in the cloud** using GitHub Actions. No powerful PC needed. Just a USB cable and `fastboot`.

</div>

---

## ✨ Features

| Feature | Status |
|---|---|
| 🐧 Mainline Linux kernel (v5.3-rc5) | ✅ Working |
| 🖥️ Plasma Mobile UI | ✅ Working |
| 🔌 USB Networking (RNDIS) | ✅ Working |
| 🔑 SSH over USB (`172.16.42.1`) | ✅ Working |
| 💾 UFS Internal Storage (`/dev/sda`) | 🔧 In Progress |
| 🖼️ Display (Samsung S6E3HA8) | 🔧 In Progress |
| 📶 Wi-Fi / Bluetooth | ⚠️ Not working yet |
| 📞 Calls / SMS | ⚠️ Modem not supported |

---

## 🚀 Quick Start

### Step 1 — Build in the cloud

1. **Fork** this repository to your GitHub account
2. Go to the **Actions** tab
3. Click **"Build postmarketOS for Pixel 3 XL"** → **"Run workflow"**
4. Configure your build:

| Option | Default | Notes |
|---|---|---|
| `ui` | `plasma-mobile` | Only confirmed working UI |
| `user_password` | `pixel3xl` | SSH login password |
| `extra_packages` | _(empty)_ | e.g. `vim,htop,tmux` |

5. ⏳ Wait **~40 minutes** for the first build (subsequent builds use `ccache` and finish in **~5 minutes**)
6. Download the **artifact ZIP** from the completed workflow run

---

### Step 2 — Flash to your phone

> ⚠️ **Requires:** Unlocked bootloader and Android Platform Tools (`fastboot`) installed

```bash
# 1. Extract the downloaded ZIP
unzip postmarketOS-crosshatch-*.zip
cd postmarketOS-crosshatch-*/

# 2. Boot your Pixel 3 XL into Fastboot
#    Power off → hold Volume Down + Power → release when you see "Fastboot Mode"

# 3. Verify USB connection
fastboot devices

# 4. Set boot slot to A (IMPORTANT for A/B partition devices)
fastboot set_active a

# 5. Flash the boot and system images
fastboot flash boot boot.img
fastboot flash userdata google-crosshatch.img

# 6. Reboot!
fastboot reboot
```

> 💡 First boot takes ~2 minutes. The screen may show the Google logo briefly — that's normal.

---

### Step 3 — Connect via SSH

```bash
# Set up the USB network interface on your PC (run once)
sudo ip addr add 172.16.42.2/24 dev usb0
sudo ip link set usb0 up

# SSH into the phone
ssh user@172.16.42.1
# Password: pixel3xl (or whatever you set in the workflow)
```

---

## 🏗️ How It Works

```
┌─────────────────────────────────────────────────────────┐
│                  GitHub Actions Runner                  │
│                                                         │
│  1. Install pmbootstrap (postmarketOS build tool)       │
│  2. Clone pmaports v25.12 (device configs + packages)   │
│  3. Apply kernel patches:                               │
│     ├─ fix_dtsi.sh → Fix SDM845 SMMU DTSI deadlock      │
│     └─ Fix Samsung panel compile error                  │
│  4. Inject UFS + display drivers into initramfs         │
│  5. Compile mainline Linux 5.3-rc5 (aarch64)            │
│  6. Build device package (crosshatch-specific)          │
│  7. Create + export flashable images                    │
│  8. Upload as downloadable GitHub artifact              │
└─────────────────────────────────────────────────────────┘
```

### Key Patches Applied

#### `fix_dtsi.sh`
This script is automatically applied during the kernel build and fixes two hardware-specific issues:

1. **SDM845 SMMU Deadlock** — The upstream `sdm845.dtsi` device tree has an incomplete SMMU (system memory management unit) node for the Adreno GPU. Without this fix, the kernel deadlocks during SMMU initialization at boot. We patch it to a working minimal configuration.

2. **Samsung Panel Compile Error** — The `panel-samsung-s6e3ha8.c` driver references a `connector->display_info.name` field that doesn't exist in the v5.3-rc5 kernel headers. We remove this call so the panel driver compiles cleanly.

---

## 📁 Repository Structure

```
crosshatch-pmos/
├── .github/
│   └── workflows/
│       └── build-pmos.yml      # Main CI/CD pipeline
├── fix_dtsi.sh                 # Kernel patch script (SMMU + display fixes)
└── README.md                   # This file
```

---

## 🛠️ Requirements

### On your PC (for flashing only)
- Linux or WSL2 on Windows
- `fastboot` — install via Android Platform Tools:
  ```bash
  # Arch / CachyOS
  sudo pacman -S android-tools

  # Ubuntu / Debian
  sudo apt install android-tools-fastboot
  ```
- USB-C cable

### On the phone
- **Unlocked bootloader** — required to flash custom images
  - Already done if you've run a custom ROM (LineageOS, Axion OS, etc.)

---

## 🔧 Advanced: Running Locally

If you want to build on your own machine instead of GitHub Actions:

```bash
# Install pmbootstrap
pip install pmbootstrap

# Initialize (select: device=google-crosshatch, ui=plasma-mobile)
pmbootstrap init

# Clone this repo
git clone https://github.com/phoenixdevellopment75-web/crosshatch-pmos.git
cd crosshatch-pmos

# Apply the kernel patches manually
cp fix_dtsi.sh ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-google-crosshatch-mainline/
pmbootstrap build linux-google-crosshatch-mainline
pmbootstrap build device-google-crosshatch
pmbootstrap install
pmbootstrap export /tmp/pmos-out
```

---

## 🐛 Troubleshooting

### Phone stuck on Google logo
The boot process is working, but the USB network (RNDIS) needs to come up on your PC:
```bash
# Check if the USB network interface appeared
ip link | grep usb

# Assign an IP and connect
sudo ip addr add 172.16.42.2/24 dev usb0
sudo ip link set usb0 up
ssh user@172.16.42.1
```

### Can't find `usb0` interface
```bash
# Try enumerating all network interfaces
ip a
# Look for something like enp0s20f0u1 or similar — use that instead of usb0
```

### Flash failed — "FAILED (remote: 'Slot count is 0')"
Make sure you run `fastboot set_active a` before flashing.

### Restore to stock Android
Download the factory image for your device from [Google's official factory images](https://developers.google.com/android/images#crosshatch) and flash with:
```bash
unzip image-crosshatch-*.zip
fastboot -w update image-crosshatch-*.zip
```

---

## 📜 License

- This build system is provided **as-is for experimental use**.
- [postmarketOS](https://postmarketos.org) is licensed under the **GPL v2+**.
- The Linux kernel is licensed under the **GPL v2**.
- Device-specific patches are derived from the [pmaports](https://gitlab.postmarketos.org/postmarketOS/pmaports) repository.

---

<div align="center">

Made with ❤️ by [@phoenixdevellopment75-web](https://github.com/phoenixdevellopment75-web)

**[postmarketos.org](https://postmarketos.org)** • **[pmaports](https://gitlab.postmarketos.org/postmarketOS/pmaports)** • **[Pixel 3 XL wiki](https://wiki.postmarketos.org/wiki/Google_Pixel_3_XL_(google-crosshatch))**

</div>
