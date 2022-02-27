---
title: "GSoC 2019 Coding Period Week 12"
date: 2019-08-20T03:03:30+00:00
draft: false
author: Loong
---

[//]: # ( UUID: b31949fc-50f2-492f-850a-025a08d8c215 )
[//]: # ( Title: GSoC 2019 Coding Period Week 12 )
[//]: # ( Created: 2019-08-20T03:03:30+00:00 )

I created a route _/things/{thing\_id}/actions_ to execute the action that the user requested through the POST. Interface description: [Actions resource](https://iot.mozilla.org/wot/#actions-resource).

To get the most realistic look, I created an [Action Example](https://www.drupal.org/sandbox/dravenk/3075952) module for testing and a template for creating actions. You can download and enable the sandbox module and add an Action to Thing as mentioned in the last [blog](https://longxianwen.net/gsoc-2019-coding-period-week-11) post. The sandbox module require a third-party package that is downloaded by the composer:

```shell
composer require ronanguilloux/php-gpio -vvv
```

An LED switch can be controlled as follows. ToggleAction's example uses this pin number: [pin17](https://git.drupalcode.org/sandbox/dravenk-3075952/blob/8.x-1.x/src/Plugin/wotapi_action/Action/ToggleAction.php#L26). Corresponding physical location and description: [https://pinout.xyz/pinout/pin11\_gpio17](https://pinout.xyz/pinout/pin11_gpio17).

**Note:** The numbering from the GPIO library is using **BCM** numbering, physical pin 11 is BCM 17.

![pin17pi](/images/pin17pi.png)

Insert the LED lamp into the raspberry pi, and then launch the Action request in Terminal. If the current state of the LED is on, sending an Action request will turn off the LED. If the current state of the LED is off, the LED will be turned on after sending an Action request. ToggleAction requires only an empty structure, similar to reboot, which you can see in the wot specification for this [commit](https://github.com/mozilla-iot/wot/pull/72/files/7da6d76b208c8832035df4a9b07fe29016f9911c#diff-eacf331f0ffc35d4b482f1d15a887d3bR265).

```shell
curl --request POST \
  --url http://192.168.2.108/wotapi/things/12744afd-62b2-4635-ba1d-fcea86e98c34/actions \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'Content-Type: application/json' \
  --data '{"toggle": {}}'
```

The action can now be executed, but the body has not yet responded to the content.  Below is the description of Action resource, and the response content is a record of execution. The current routing builds are very similar to the JSON:API in that they build Entity resources, such as Thing Entity or property Entity. But the execution record of an Action is not yet recorded in the entity. The next step is to consider how to respond to the Action execution record.

[EXAMPLE 12](https://iot.mozilla.org/wot/#example-12-response-to-creating-an-action-request): Response to creating an action request

```json
201 Created

{
  "fade": {
    "input": {
      "level": 50,
      "duration": 2000
    },
    "href": "/things/lamp/actions/fade/123e4567-e89b-12d3-a456-426655",
    "status": "pending"
  }
}
```
