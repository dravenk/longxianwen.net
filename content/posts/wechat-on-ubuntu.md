---
title: "Wechat on Ubuntu"
date: 2022-02-27T16:21:13+08:00
draft: true
---

Fix some error

```bash
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
```

```bash
sudo ldconfig -p | grep -i GL.so
sudo rm /lib/i386-linux-gnu/libGL.so.1
```
