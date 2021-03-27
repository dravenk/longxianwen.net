---
title: "Installing Arch Linux in my computer"
date: 2020-07-19T02:57:32+00:00
draft: false 
---

[//]: # ( UUID: c7ee4ab9-9e4c-478b-81bb-8cbf354709e3 )
[//]: # ( Title: Installing Arch Linux in my computer )
[//]: # ( Created: 2020-07-19T02:57:32+00:00 )

Yesterday I installed [ArchLinux](https://www.archlinux.org/) on my desktop and the installation was basically smooth. But I'd like to record some basic operations just to make a note. [Archlinux Installation Guide](https://wiki.archlinux.org/index.php/installation_guide) is very well documented and is recommended to read.  I use the [balenaEtcher](https://www.balena.io/etcher/ ) to flash the iso file to my USB disk. I recommend watching this [video](https://youtu.be/NchV5UphQeQ) to learn the installation process. Some of the content in the video is out of date, and you may not be able to boot the system if you follow the video exactly. For example, the

```
pacstrap /mnt base base-devel
```

 command in the video should now be replaced by

```
pacstrap /mnt base linux linux-firmware
```

This is the reason why still recommended reading documentation  [Archlinux Installation Guide](https://wiki.archlinux.org/index.php/installation_guide).

Since I'm using Wi-Fi, I need to set up wifi before I can install it. This is also available in the documentation [Connecting with wpa\_passphrase](https://wiki.archlinux.org/index.php/Wpa_supplicant#Connecting_with_wpa_passphrase) . Use command to check the network card statues:

```
ip link
```

My example is wlan0, and then connect wifi. If the SSID and password are correct, wi-fi will be connected.

```
# wpa_supplicant -B -i wlan0 -c <(wpa_passphrase My-wifi-SSID ThisisSSIDPassword)
```

Don't forget ping example.com to test network.

Here are some recorded commands:

```
# lsblk

```

Create partitions. I created the /boot partition /swap partition, and the /system partition use cgdisk command.

```
# cgdisk

```

Set ef00 the " Hex core or GUID" to /boot partition. Set 8200 the " Hex core or GUID" to /swap partition. Set 8300 the " Hex core or GUID" to /system partition.

Format the partition. See  documentation [EFI system partition](https://wiki.archlinux.org/index.php/EFI_system_partition#Format_the_partition)

```
# mkfs.fat -F32 /dev/nvme1n1p1
```

Initialize [swap](https://wiki.archlinux.org/index.php/Swap):

```
# mkswap /dev/nvme1n1p2
# swapon /dev/nvme1n1p2
```

Formatted with an appropriate file system.

```
# mkfs.ext4 /dev/nvme1n1p3
```

Mount the file systems and check with df.

```
# mount /dev/nvme1n1p3 /mnt
# mkdir /mnt/boot
# mount /dev/nvme1n1p1 /mnt/boot
# df

```

Move the fastest address in the Mirror to the top before installing the system

```
# pacman -Sy vim
# vim /etc/pacman.d/mirrorlist
```

Installation. [Install essential packages.](https://wiki.archlinux.org/index.php/installation_guide#Install_essential_packages)

```
# pacstrap /mnt base linux linux-firmware
```

Generate an fstab file (use -U or -L to define by UUID or labels, respectively):

```
# genfstab -U /mnt >> /mnt/etc/fstab
```

Change root into the new system:

```
# arch-chroot /mnt
Set the time zone:
```

```
# ln -sf /usr/share/zoneinfo/Hongkong /etc/localtime

```

Run hwclock(8) to generate /etc/adjtime:

```
# hwclock --systohc

```

Edit /etc/locale.gen and uncomment en\_US.UTF-8 UTF-8,  zh\_CN.UTF-8 UTF-8, zh\_HK.UTF-8 UTF-8 and other needed locales. Generate the locales by running:

```
# vim /etc/locale.gen
# locale-gen
```

Create the locale.conf(5) file, and set the LANG variable accordingly:

```
# echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

Create the hostname file:

```
# echo "myhostname" > /etc/hostname
```

Set the password for root user.

```
# passwd
```

Create a user and gave sudo permissions.

```
# useradd -g users -G wheel,storage,power -m myname
# passwd myname
# pacman -S sudo
# vim /etc/sudoers
```

Choose and install a Linux-capable [boot loader](https://wiki.archlinux.org/index.php/Arch_boot_process#Boot_loader).

```
# pacman -S grub efibootmgr
```

Use [GRUB](https://wiki.archlinux.org/index.php/GRUB) to install boot.

```
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

Use the grub-mkconfig tool to generate /boot/grub/grub.cfg:

```
# grub-mkconfig -o /boot/grub/grub.cfg
```

**Important.**

Install Wi-Fi manager use command like wifi-menu(netctl) command:

```
# pacman -S iw wpa_supplicant dialog dhcpcd netctl netctl

```

Set wifi auto connection after reboot

```
# ip link
# systemctl enable netctl-auto@wlo1.service
```

Set Chinese font, otherwise I can't see Chinese

```
#pacman -S wqy-microhei wqy-microhei-lite wqy-zenhei wqy-bitmapfont
```

I have a Bluetooth speaker, so I'll start bluetooth connectivity by default.

```
# systemctl enable bluetooth.service
```