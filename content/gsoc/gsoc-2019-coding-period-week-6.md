---
title: "GSoC 2019 Coding Period Week 6"
date: 2019-07-06T08:16:42+00:00
draft: false
author: Loong
---

[//]: # ( UUID: 30bafe41-23c2-4611-a564-672a153de601 )
[//]: # ( Title: GSoC 2019 Coding Period Week 6 )
[//]: # ( Created: 2019-07-06T08:16:42+00:00 )

In the past few weeks, I have been thinking: why does the Property object in [Thing resource](https://iot.mozilla.org/wot/#thing-resource) not contain the value of the Thing property? It's clear that `type` refers to the type of value the property stores, and the property itself is an Object containing fields such as title, description, and so on.

Property object:

```json
  "temperature": {
    "title": "Temperature",
    "type": "number",
    "unit": "degree celsius",
    "readOnly": true,
    "description": "An ambient temperature sensor",
    "links": [{"href": "/things/pi/properties/temperature"}]
  }
```

Project resource:

```json
{
  "temperature": 21
}
```

If the Property object temperature is a content entity, how to store the 21? If the title and description are definition fields of Property type. Does that mean that the 'type' above is also part of the property type definition? So 21 must have an additional field store.  However, the type above will not guarantee that the value of the Thing property is correct in this way. Of course, this is probably the quickest way to do it.

OnOffProperty

- bedroom lamp switch
- kitchen lamp switch
- fan switch

BrightnessProperty

- bedroom lamp brightness
- kitchen lamp brightness

TemperatureProperty

- bedroom air-condition temperature
- living room air-condition temperature

As for the relationship between the instance of Thing property and Thing, it can be seen from the above information that I can understand the way. When I added a Thing, I needed to fill in the label of the property instance. When the mentor saw the label in Thing property, he thought my custom Thing property was wrong. I said the ‘switch' just a label. It is really a Thing property entity. If a Thing property instance that is not created does not have a label and use a default widget, I will get a confusing following.

![autocomplete](/images/123_0.png)

Although I was confused by the figure above, the mentor saw that the label of the property added in Thing was more difficult to understand. Perhaps he understood something else. I deleted the label of the base field defined in the Property to reduce confusion among users. In another [post](https://longxianwen.net/gsoc-2019-coding-period-week-5) I wrote about using [Inline entity form](https://www.drupal.org/project/inline_entity_form), you can edit the value of a Thing property when you create it, as shown below.

![ief1](/images/ief1.png)

Just like the above example: {"temperature": 21}, there is a very important question: how to store the value of the property? Since Thing property is an entity, I need to store the value of Thing property by adding fields. The reason for adding fields to the interface is that it leaves open the possibility of allowing the user to create a custom Thing property. If the field is already defined as a Boolean, it can no longer be defined as an integer. Because the Machine name is unmodifiable.  So, I will add a field like field\_boolean, field\_string, field\_integer and so on, but the label still is 'value'.

![value](/images/value.png)

Property names defined in [http://iotschema.org/](http://iotschema.org/) and [https://iot.mozilla.org/schemas](https://iot.mozilla.org/schemas) end with fixed Property and Data. In the example of specification, the Property ending is added by capitalization excepted @type. Indexed of Property is always lowercase. Therefore, when defining the bundle of Thing Property, the machine-read name does not end with Property or Data. There are some things that I don't understand, so I will temporarily not create the corresponding Thing property bundle:

- [MotionTypeData](http://iotschema.org/MotionTypeData)

  Expected Type: [MotionSensorType](http://iotschema.org/MotionSensorType)

- [RunModeData](http://iotschema.org/RunModeData)

  Expected Type: [RunModeType](http://iotschema.org/RunModeType)

Property definition in [http://iotschema.org/](http://iotschema.org/) is not as clear as [https://iot.mozilla.org/schemas](https://iot.mozilla.org/schemas), for example:

[WindData](http://iotschema.org/WindData) has a value type of number but does not indicate whether it is float or integer.

![iotwind](/images/iotwindata.png)

[TemperatureProperty](https://iot.mozilla.org/schemas/#TemperatureProperty) specifies the value is an integer.

![wottem](/images/wottem.png)