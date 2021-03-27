---
title: "GSoC 2019 Coding Period Week 10"
date: 2019-08-02T08:30:49+00:00
draft: false 
---

[//]: # ( UUID: 5b3bb85d-df9b-412a-b796-f749fa57717d )
[//]: # ( Title: GSoC 2019 Coding Period Week 10 )
[//]: # ( Created: 2019-08-02T08:30:49+00:00 )

I don't think actions should be predefined. This is the description of the [Action object](https://iot.mozilla.org/wot/#action-object).

> 2.11 Action object
>
> An action object describes a function which can be carried out on a device.

Take a blinking LED on plugged into a [Raspberry Pi](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) as an example. I followed the tutorial [Blinking LED on Raspberry Pi using Golang](https://www.admfactory.com/blinking-led-on-raspberry-pi-using-golang/) and succeeded in making the LED blinking. I need to customize the GPIO pin and set the pin to output mode. This is not predefined.

I think even though [Actions](https://iot.mozilla.org/schemas/#actions) Input and so on are defined, how to operate the hardware cannot be predefined according to the specification.

![actions](/images/actions_0.png)

[Action object](https://iot.mozilla.org/wot/#action-object) content, such as the properties and [https://iot.mozilla.org/schemas/#actions](https://iot.mozilla.org/schemas/#actions) is the same as above except for the unit. One is second and another in milliseconds.

![action-object](/images/action-object.png)

The description of the Action Object is similar to the functionality provided by [JSON:RPC](http://drupal.org/project/jsonrpc), which also provides remote procedure calls. The execute() method in JSON:RPC example: [https://www.lullabot.com/articles/jsonrpc-to-decouple-everything-else](https://www.lullabot.com/articles/jsonrpc-to-decouple-everything-else). The Action must be like JSON:RPC, allowing the user to customize the execute() method.

```
  /**
   * {@inheritdoc}
   *
   * @throws \Drupal\jsonrpc\Exception\JsonRpcException
   */
  public function execute(ParameterBag $params) {
    // [Code simplified for the sake of the example]
    $paginator = $params->get('page');
    $service = $params->get('service');
    $definitions = $this->container->get($service)->getDefinitions();
    return array_slice($definitions, $paginator['offset'], $paginator['limit']);
  }
```

That is the [_outputSchema()_](https://git.drupalcode.org/project/jsonrpc/blob/8.x-1.x/src/Plugin/JsonRpcMethodBase.php#L67) method that the user needs to implement in JSON:RPC.

The following code can be found in the [mozilla-iot/webthing-node](https://github.com/mozilla-iot/webthing-node) project [single-thing.js](https://github.com/mozilla-iot/webthing-node/blob/master/example/single-thing.js#L37), which is how you create things and add actions.

```
function makeThing() {
  const thing = new Thing('urn:dev:ops:my-lamp-1234',
                          'My Lamp',
                          ['OnOffSwitch', 'Light'],
                          'A web connected lamp');
  // ...
  thing.addAvailableAction(
    'fade',
    {
      title: 'Fade',
      description: 'Fade the lamp to a given level',
      input: {
        type: 'object',
        required: [
          'brightness',
          'duration',
        ],
        properties: {
          brightness: {
            type: 'integer',
            minimum: 0,
            maximum: 100,
            unit: 'percent',
          },
          duration: {
            type: 'integer',
            minimum: 1,
            unit: 'milliseconds',
          },
        },
      },
    },
    FadeAction);
  //...
  return thing;
}
```

This is the definition of the [addAvailableAction()](https://github.com/mozilla-iot/webthing-node/blob/0c6497de79c3ea6de82fc0792152a8e05e7259d9/lib/thing.js#L462) method invoked by the code above

```
  /**
   * Add an available action.
   *
   * @param {String} name Name of the action
   * @param {Object} metadata Action metadata, i.e. type, description, etc., as
   *                          an object.
   * @param {Object} cls Class to instantiate for this action
   */
  addAvailableAction(name, metadata, cls) {
    if (!metadata) {
      metadata = {};
    }

    this.availableActions[name] = {
      metadata: metadata,
      class: cls,
    };
    this.actions[name] = [];
  }
```

This is how actions return as a description. [https://github.com/mozilla-iot/webthing-node/blob/master/lib/thing.js#L72](https://github.com/mozilla-iot/webthing-node/blob/master/lib/thing.js#L72)

```
asThingDescription() {
//...
  for (const name in this.availableActions) {
    thing.actions[name] = this.availableActions[name].metadata;
    thing.actions[name].links = [
      {
        rel: 'action',
        href: `${this.hrefPrefix}/actions/${name}`,
      },
    ];
  }
//...
}
```

So I think I should not pre-define actions, but provide documentation and examples of how to add actions. This module will build canonical and secure routes like the [mozilla-iot/ webthy-node](https://github.com/mozilla-iot/webthing-node) project in this way, and will also provide methods to execute and output patterns like the JSON:RPC project. Users need to implement these methods themselves. I think Action is handled as follows.

- Add to methods that can be executed with params.
- Provides the schema that describes the results of the Thing Action.