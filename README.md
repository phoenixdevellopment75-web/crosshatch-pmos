# postmarketOS Builder for Pixel 3 XL (crosshatch)

Build postmarketOS images for Google Pixel 3 XL in the cloud using GitHub Actions.  
No need for a powerful local machine — just `fastboot` and a USB cable.

## Quick Start

1. **Fork or push** this repo to your GitHub account
2. Go to **Actions** tab → **"Build postmarketOS for Pixel 3 XL"**
3. Click **"Run workflow"** and choose:
   - **UI**: `plasma-mobile` (recommended — only confirmed working UI)
   - **Password**: your SSH login password
   - **Extra packages**: optional (e.g., `vim,htop,tmux`)
4. Wait **~20-40 minutes** for the build
5. **Download** the artifact zip from the completed workflow run

## Flashing

```bash
# Unzip the downloaded artifact
unzip postmarketOS-crosshatch-*.zip
cd postmarketOS-crosshatch-*/

# Boot Pixel 3 XL into fastboot:
#   Power off → hold Volume Down + Power → release at "Fastboot Mode"

# Verify connection
fastboot devices

# Set active slot (CRITICAL for A/B devices)
fastboot set_active a

# Flash
fastboot flash boot boot.img
fastboot flash userdata google-crosshatch.img

# Reboot
fastboot reboot
```

## After Flashing

```bash
# Connect phone via USB, then SSH in:
ssh user@172.16.42.1
# Enter the password you set in the workflow

# If SSH doesn't connect, set up the USB network manually:
sudo ip addr add 172.16.42.2/24 dev usb0
sudo ip link set usb0 up
ssh user@172.16.42.1
```

## Requirements

### On your local PC (for flashing only)
- `fastboot` (Android platform tools)
- USB-C cable
- Linux (or WSL2 on Windows)

### On the phone
- Unlocked bootloader
- Already done if running a custom ROM (e.g., Axion OS)

## Notes

- **Screen**: Only works with Plasma Mobile UI. May be blank with other UIs.
- **Wi-Fi/Bluetooth**: Currently broken — fix after install.
- **SSH via USB**: Always works, even with blank screen.
- **Go back to Android**: Flash stock from [Google factory images](https://developers.google.com/android/images#crosshatch).

## License

This workflow is provided as-is for experimental use.  
postmarketOS is licensed under the GPL. See [postmarketos.org](https://postmarketos.org).
