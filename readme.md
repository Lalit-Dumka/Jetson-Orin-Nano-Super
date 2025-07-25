# Jetson-Orin-Nano-Super Setup

Set up your NVIDIA Jetson Orin Nano Developer Kit with **JetPack 6.x**, enable **MAXN SUPER** power mode, and install essential computer‑vision libraries—all via an easy-to-use script.

## 🧰 Table of Contents

- [Jetson-Orin-Nano-Super Setup](#jetson-orin-nano-super-setup)
  - [🧰 Table of Contents](#-table-of-contents)
  - [Prerequisites](#prerequisites)
  - [0. Check current firmware version](#0-check-current-firmware-version)
  - [1. Upgrade to “Super” mode](#1-upgrade-to-super-mode)
  - [2. Flashing the microSD card](#2-flashing-the-microsd-card)
  - [3. Install CV libraries via setup script](#3-install-cv-libraries-via-setup-script)
    - [Usage Example](#usage-example)
  - [Go Headless](#go-headless)
  - [create\_8gb\_swap.sh](#create_8gb_swapsh)
  - [create\_jetson\_clocks\_service.sh](#create_jetson_clocks_servicesh)
  - [References](#references)

---

## Prerequisites

- A host PC with **balenaEtcher** installed for flashing the microSD card.
- A Jetson Orin Nano Developer Kit.
- A blank **microSD card** (64 GB+ recommended) or optionally NVMe SSD.

---

## 0. Check current firmware version

To check the current firmware version of your Jetson Orin Nano, follow these steps:

1. **Power on the device**: Insert the microSD card and power on the Jetson Orin Nano.
2. **Observe the boot screen**: While the device is booting, look at the top-middle of the screen. The firmware version will be displayed there.
3. **Note the version**: If the version is less than 36.0, you need to upgrade to JetPack 5.1.3 first before proceeding with JetPack 6.x. Go to step 1 below if it is < 36.0.
4. **If version is >= 36.0**: You can proceed directly to flashing the microSD card with JetPack 6.x. Go to step 2 below.

---

## 1. Upgrade to “Super” mode

If the module shipped with older firmware (< 36.0), first flash JetPack 5.1.3 to schedule an intermediate firmware update, then repeat with JetPack 6.x.

1. **Check current firmware version**: While the device id getting booted you will see the firmware version in top-middle of the screen. If it is < 36.0, you need to flash JetPack 5.1.3 first.
2. **Download JetPack 5.1.3**: Go to the [Jetpack 5.1.3 Official Image][1] and download the 5.1.3 SD card image.
3. **Flash the SD card**: Use balenaEtcher to flash the JetPack 5.1.3 image onto the microSD card.
4. **Boot the device**: Insert the SD card into the Jetson Orin Nano and power it on. Complete the OEM setup as before.
5. **Wait for the system to boot**: After the initial setup, wait about 5 minutes after powering on the device to allow the firmware update to complete. Then **reboot** the device.
6. **Check firmware version again**: After rebooting, check the firmware version again. It should now be 35.5.0. Ready to upgrade to JetPack 6.x (firmware >= 36.0).
7. **Install QSPI updater**: Connect to internet and install the QSPI updater by running the following command in the terminal:

    ```bash
    sudo apt-get install nvidia-l4t-jetson-orin-nano-qspi-updater
    ```

8. **Reboot and observe update**: After installing the QSPI updater, reboot the device. You would see the update process and after that it tries to reboot but gets struck. This is expected as it now ready to be flashed with JetPack 6.x.

---

## 2. Flashing the microSD card

Check if Jetson UEFI Firmware version > 36.0. If not, you need to flash JetPack 5.1.3 first to update the firmware before proceeding with JetPack 6.x. If <36.0 go to step 1 first.

Use NVIDIA’s official microSD image (JetPack 6.x) and **balenaEtcher** to write it:

- Download the latest JetPack 6.x SD card image from NVIDIA. Download link: [Jetpack 6.x Official Image][2].
- Launch **balenaEtcher**, select the image (ZIP is fine), choose your SD card, and click Flash.
- Insert the SD card into the Orin Nano and power it on.
- Complete the **OEM setup**: accept EULA, language, networking, create username, etc.
- **Wait for the system to boot**: After the initial setup, wait about 5 minutes after powering on the device to allow the firmware update to complete. Then **reboot** the device.
- **Check super mode**: At the top ight corner of the screen, you should see power modes indicating that the device is now in Super mode.
- If you cannot see the power modes, run the following command in the terminal:

    ```bash
    sudo rm -rf /etc/nvpmodel.conf
    ```

    and then reboot the device.
  
---

## 3. Install CV libraries via setup script

Clone this repository to your Jetson device and run the provided bash installer:

```bash
git clone https://github.com/lalit-dumka/jetson-orin-nano-super.git
cd Jetson-Orin-Nano-Super
chmod +x LD_JONS.sh
bash ./LD_JONS.sh -b -v -l
```

It will install the following libraries:
torch, torchvision, numpy, ultralytics, opencv-python, opencv-contrib-python, xmlschema, loguru, onnx, onnxruntime, onnxruntime-gpu (CUDA and TensorRT come pre-installed with JetPack 6.x), and more.

Options (`-b`, `-v`, `-l`, `-o`) allow optional installation of **Brave**, **VS Code**, **VLC**, and **OpenCV with CUDA**, respectively.

---

### Usage Example

```bash
sudo ./setup_jetson_orin.sh -b -v -l
```

---

## Go Headless

If you want to run your Jetson Orin Nano Super headless (without a monitor) persistently, you can set it up to run in headless mode. This is useful for remote access and running applications without a display.
To enable headless mode, run the following command:

```bash
sudo systemctl set-default multi-user.target
```

To revert back to graphical mode, run:

```bash
sudo systemctl set-default graphical.target
```

---

## create_8gb_swap.sh

- **Purpose**: Automates the creation and activation of a swap file on Linux systems (Nvidia Jetson Orin Nano Super here).
- **Use**:
  - Prompts the user for the desired swap size (default is 8GB).
  - Sets up the swap file with higher priority for optimal performance.
  - Ensures persistence by adding the swap file entry to `/etc/fstab`.

## create_jetson_clocks_service.sh

- **Purpose**: Automates the creation and activation of a systemd service for Jetson devices.
- **Use**:
  - Creates a `jetson_clocks.service` file to run the Jetson Clocks utility with the `--fan` option.
  - Reloads the systemd daemon and enables the service for persistence.
  - Starts the service automatically after creation.

You're all set! 🎉 Enjoy full‑performance Jetson Orin Nano Super with your CV stack ready to go.

---

## References

- [Jetson AI Lab Initial Setup Guide][3]

---

[1]: https://developer.nvidia.com/downloads/embedded/l4t/r35_release_v5.0/jp513-orin-nano-sd-card-image.zip "Jetpack 5.1.3 Official Image"
[2]: https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.3/jp62-orin-nano-sd-card-image.zip "Jetpack 6.x Official Image"
[3]: https://www.jetson-ai-lab.com/initial_setup_jon.html "Jetson AI Lab Initial Setup Guide"
