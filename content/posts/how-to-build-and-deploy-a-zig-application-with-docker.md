---
title: "How to Build and Deploy a Zig Application With Docker"
date: 2024-03-10T08:06:50+01:00
draft: false
author: Loong
tag: gsoc
---

# How to Build and Deploy a Zig Application With Docker

Now, the zig can be install from a package manager. We create a dockerfile to install zig. We use alpine linux to make the docker image as mininal as possiable. We can simply install zig with apk package manager, event it's only aliveable for testing version.

```dockerfile
FROM alpine:edge
# zig is currently only in testing
RUN apk --no-cache add zig --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN mkdir -p /opt/app
WORKDIR /opt/app
```

The is all content we need. It's so simply just that language. Now, we can use this dockerfile to build our image.

## Usage

```bash
docker build -t ziglang .
```

```bash
docker run -it --rm ziglang
```

Go to the application directory and use zig in docker to build and run your application. For example. Create a [hello-world](https://ziglang.org/documentation/master/#Hello-World) program and run it with docker.
```bash
echo '
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, world!\n", .{});
}
' > hello.zig
```
Now, run your `hello-world` program.
```bash
docker run -it --rm -v $PWD:/opt/app ziglang zig run hello.zig
```

Reference:
[docker-zig](https://github.com/dravenk/docker-zig)