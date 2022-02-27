---
title: "Research of module names and related discussion of data structures"
date: 2019-06-10T07:38:10+00:00
draft: false
author: Loong
---

[//]: # ( UUID: 2d9c20ba-e29a-407b-bb95-30266b62f30f )
[//]: # ( Title: Research of module names and related discussion of data structures )
[//]: # ( Created: 2019-06-10T07:38:10+00:00 )

This is the second week of coding for the [GSoC](https://summerofcode.withgoogle.com/) project. Mentor advised me to create the Thing Entity and Property Entity last week. So, I created these two entities and created the test data. This week I showed to mentor the response in API. The response in API like bellow.

```json
GET http://dp.localhost/wotapi/thing/thing/64a6d86d-1f63-4f9c-aa7a-7d194e1e54c9
{
  "type": "thing--thing",
  "id": "64a6d86d-1f63-4f9c-aa7a-7d194e1e54c9",
  "drupal_internal__id": 1,
  "name": "WoT Pi",
  "description": "A WoT-connected Raspberry Pi",
  "langcode": "und",
  "created": "2019-06-10T07:49:43+00:00",
  "changed": "2019-06-10T07:49:58+00:00",
  "user_id": {
    "type": "user--user",
    "id": "f9a8935f-1cb2-463e-af64-0d14439cf913",
    "links": [
      {
        "href": "http://dp.localhost/wotapi/thing/thing/64a6d86d-1f63-4f9c-aa7a-7d194e1e54c9/user_id"
      }
    ]
  },
  "properties": {
    "a40f9174-1258-4d9d-b5e2-699e7a481195": {
      "type": "property--property",
      "id": "a40f9174-1258-4d9d-b5e2-699e7a481195"
    },
    "74f6c04b-f3fa-4d56-bf45-4df87155bf88": {
      "type": "property--property",
      "id": "74f6c04b-f3fa-4d56-bf45-4df87155bf88"
    },
    "0c295785-26bd-4c3a-861c-855d8f54cdaa": {
      "type": "property--property",
      "id": "0c295785-26bd-4c3a-861c-855d8f54cdaa"
    },
    "links": [
      {
        "href": "http://dp.localhost/wotapi/thing/thing/64a6d86d-1f63-4f9c-aa7a-7d194e1e54c9/properties"
      }
    ]
  },
  "links": [
    {
      "rel": "thing--thing",
      "href": "http://dp.localhost/wotapi/thing/thing/64a6d86d-1f63-4f9c-aa7a-7d194e1e54c9"
    },
    {
      "rel": "user_id",
      "href": "http://dp.localhost/wotapi/thing/thing/64a6d86d-1f63-4f9c-aa7a-7d194e1e54c9/user_id"
    },
    {
      "rel": "properties",
      "href": "http://dp.localhost/wotapi/thing/thing/64a6d86d-1f63-4f9c-aa7a-7d194e1e54c9/properties"
    }
  ]
}

```

The mentor asked me a few questions.

1. Why the bash path is `wotapi`?
2. Why is `/thing/thing/`?
3. Why is not `/things/lamp`, If I created a lamp?

My answers are

1. It's this module name like the jsonapi module. The '/wotapi' is like the '/jsonapi' is the base path.
2. The first '/thing' is an entity type. The second '/thing' is a bundle of the entity type. Just like jsonapi.
3. Look at the [https://iot.mozilla.org/wot/#thing-resource](https://iot.mozilla.org/wot/#thing-resource) Example: Get a description of a Thing

  ```json
    ...
    REQUEST
    GET http://mythingserver.com/things/pi
    ...
  ```

There are only '/things'. The 'pi' is this thing name. It's not mean just create a thing entity and naming 'lamp'? All those are things. Why need more a bundle?

What should be indexed of Property? In the above response. I use the UUID to be indexed of property because UUID is every entity indexed in Drupal. But it's not human-friendly to be indexed. Look at the example [https://iot.mozilla.org/wot/#example-6-property-object](https://iot.mozilla.org/wot/#example-6-property-object)

> A property object describes an attribute of a Thing and is indexed by a property id.

```json
"level" : {
  "title": "Level",
  "description": "The level of light from 0-100",
  "@type": "LevelProperty",
  "type": "integer",
  "unit": "percent",
  "minimum": 0,
  "maximum": 100,
  "readOnly": false,
  "links": [{"href": "/things/lamp/properties/level"}]
}
```

Look at this example. Indexed is very similar to a lowercase title. Then I show a relevant page of property schemas to my mentor. On this page show me some property examples [https://iot.mozilla.org/schemas/#properties](https://iot.mozilla.org/schemas/#properties). After reading this information, the mentor thought I need to hard-code the above examples. What puzzles me is that an example of [this page](https://iot.mozilla.org/wot/#thing-resource) is not included in the above material.

Another question. Should the Property entity support bundle? I think yes. Look at the [example](https://iot.mozilla.org/schemas/) again. There are show us two difference property type. One is a boolean type, another is an integer. They have different fields. For example, the minimum and maximum required by integer are not required by Boolean types. So I think property entity needs to support bundles. The different types of properties you create can have different fields.

```json
  "properties": {
    "on": {
      "@type": "OnOffProperty",
      "type": "boolean",
      "description": "Whether the lamp is turned on",
      "href": "/things/lamp/properties/on"
    },
    "brightness" : {
      "@type": "BrightnessProperty",
      "type": "integer",
      "description": "The level of light from 0-100",
      "minimum" : 0,
      "maximum" : 100,
      "href": "/things/lamp/properties/brightness"
    }
  }
```

I still develop on my local computer. I need to name this module. So, I ask the mentor which name should be choice? Mentor asks me the same question what is my research about the module name? And what about the submodule Thing and Property?

I think WOT is a good name because WOT stands for Web of Thing. For example, the w3c uses WOT to name projects  [https://github.com/w3c/wot](https://github.com/w3c/wot), and Mozilla uses wot as the URI of the Web Thing API [https://iot.mozilla.org/wot/](https://iot.mozilla.org/wot/). But the wot name is already used in Drupal contributed module, so I came up with another name: WOTAPI. This name is also very similar to the JSONAPI module. Similarly, submodules are not called property and thing. The submodules will be named like wotapi\_property and wotapi\_thing. The directory structure will then look like this:

```bash
 src
   /modules
      /wotapi_property
      /wotapi_thing

```

The submodule of [commerce](https://www.drupal.org/project/commerce) contains commerce\_, the submodule of [jsonrpc](https://www.drupal.org/project/jsonrpc) contains jsonrpc\_, and the submodule of [examples](https://www.drupal.org/project/examples) also contains \_example, so I think it is acceptable according to this practice.
