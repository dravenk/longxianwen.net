---
title: "GSoC 2019 Coding Period Week 11"
date: 2019-08-13T13:23:51+00:00
draft: false
author: Loong
---

[//]: # ( UUID: 1bcf93a9-93db-4883-a295-e94ac494e7d6 )
[//]: # ( Title: GSoC 2019 Coding Period Week 11 )
[//]: # ( Created: 2019-08-13T13:23:51+00:00 )

To enable the user to add a Thing Action to a Thing, I create a custom Thing action field to associate the user-created Thing Action with a Thing.

![thing_action_field](/images/thing_action_field.png)

The user needs to create a custom Thing Action and then choose which Thing Action to add when creating a Thing.

```php
/**
 * Fades a multi level switch to a given level over a given duration.
 *
 * @WotapiAction(
 *   id = "fade",
 *   access = {"administer site configuration"},
 *   description = "Fades a multi level switch to a given level over a given duration.",
 *   at_type = "FadeAction",
 *   title = "Fade",
 * )
 */
class FadeAction extends WotapiActionBase {
```

Used to define the input data schema of the action.

```php
  /**
   * {@inheritdoc}
   */
  public static function input() {
    return [
      'type' => 'object',
      'properties' => [
        'brightness' => [
          'type' => 'integer',
          'minimum' => 0,
          'maximum' => 100,
        ],
        'duration' => [
          'type' => 'integer',
          'minimum' => 0,
          'unit' => 'milliseconds',
        ],
      ],
    ];
  }
```

After the user has coded an Action, user can add a Thing Action when creating a Thing

![toggle](/images/toggle.png)

According to the specification, it should be possible to retrieve the Action object's information in the /things interface.

> 2.11 Action object
>
> An action object describes a function which can be carried out on a device.

In discussions with the [mozilla-iot/webthing-node](https://github.com/mozilla-iot/webthing-node/issues/113#issuecomment-517934133) project maintainers, I will use the brightness test.

> Also, the input for your action was invalid (you used level instead of brightness) -- unless you're on a super old version of the library.

![thing_actions](/images/thing_actions.png)

Finally, the _::execute()_ method does the actual work. It is not yet possible to invoke the custom _::execute()_ method.But that's how Thing action works.

```php
  /**
   * {@inheritdoc}
   */
  public function execute(ParameterBag $params) {
    // A function which can be carried out on a device
    return;
  }
```
