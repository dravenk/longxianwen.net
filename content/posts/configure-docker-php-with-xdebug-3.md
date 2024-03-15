---
title: "Configure Docker PHP with Xdebug 3"
date: 2020-12-25T18:07:43+00:00
draft: false
author: Loong
tag: post
---

[//]: # ( UUID: 70c703f9-76ca-404d-8ab0-dba749e851b2 )
[//]: # ( Title: Configure Docker PHP with Xdebug 3 )
[//]: # ( Created: 2020-12-25T18:07:43+00:00 )

These days I am using LDAP to integrate with an authentication system in the project. So I using the [LDAP module](https://www.drupal.org/project/ldap). During the use of LDAP, several issues were submitted, I was happy that the maintainer was active in the module, and I was very glad that several patches were merged. One of the patches needs to submit a test at the suggestion of the maintainer.

  Since I've spent most of the past year writing about theming code, I've made a number of changes to the PC development environment, including resetting the laptop. I need to reconfigure the environment necessary to run the tests. At the same time, I updated the latest Drupal image using PHP 8 and XDebug 3.

The Xdebug3 has a number of changes from version 2, including configuration changes. Now that I'm using Version 3, I won't post a version 2 configuration. Below is the configuration for Xdebug 3 in Dockerfile.

```dockerfile
# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
# See https://xdebug.org/docs/remote
RUN { \
    echo '[xdebug]'; \
    echo 'xdebug.mode=develop,coverage,debug'; \
    echo 'xdebug.start_with_request=yes'; \
    echo 'xdebug.discover_client_host=true'; \
    echo 'xdebug.client_host=host.docker.internal'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

```

Here are the concrete parameters can be found at [https://xdebug.org/docs/remote](https://xdebug.org/docs/remote). One parameter that is easy to ignore is 'xdebug.client\_host=host.docker.internal'. This parameter was found to be necessary in my tests. Because the default port of Xdebug is changed, the corresponding configuration file for VsCode is changed. Below is the configuration for vscode.

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "pathMappings": {
          "/opt/drupal/web": "${workspaceRoot}"
      },
      "log": true,
      "port": 9003,
      "externalConsole": false,
      "ignore": [
          "**/vendor/**/*.php"
      ]
    }
  ]
}

```

In some older applications, changing "/opt/drupal/web" to "/var/www/html" would work fine.
