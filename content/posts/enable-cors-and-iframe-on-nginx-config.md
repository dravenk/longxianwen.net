---
title: "Enable CORS and iframe on Nginx config"
date: 2022-02-27T16:07:48+08:00
draft: false
author: Loong
summary: "Some simple configuration documents."
tag: post
---

Some simple configuration documents.

```nginx
  location / {
    proxy_ssl_server_name on;
    proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    proxy_ssl_protocols SSLv3;
    proxy_pass http://myapp/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Http-Scheme https;

    # Enable iframe
    proxy_hide_header X-Frame-Options;

    # Enable Cros
    add_header Access-Control-Allow-Origin *;

    # Javascript request upgrade http to https
    add_header Content-Security-Policy upgrade-insecure-requests;

  }
```

Some doc:

[nginx-cors-open-configuration](https://michielkalkman.com/snippets/nginx-cors-open-configuration/
)
