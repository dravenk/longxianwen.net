---
title: "Research how to design properties/actions/events API in Drupal"
date: 2019-05-29T04:12:54+00:00
draft: false 
---

[//]: # ( UUID: 98470898-dbea-4b38-ba6e-c564c9636528 )
[//]: # ( Title: Research how to design properties/actions/events API in Drupal )
[//]: # ( Created: 2019-05-29T04:12:54+00:00 )

When coding started, I have a problem, that is how to create a Thing with properties/actions/events.  How can I get the data to result If no data input?

  Then I read the document again and looked for relevant information. The thing description on this page [https://iot.mozilla.org/wot/#thing-resource](https://iot.mozilla.org/wot/#thing-resource). “A thing Resource provides a Thing Description for a device. A Thing Resource is considered the root resource of a Thing.” About the properties. [https://iot.mozilla.org/wot/#properties-resource](https://iot.mozilla.org/wot/#properties-resource).”A property resource represents all the properties of a device. The value of all properties can be retrieved with an HTTP GET request.”

  The first thing that came to my mind was a question. Should I create an entity name Thing or reference entity property? But, how to do with actions and events in the same way? From the example of response, they are the same of property for Thing.

  After I read another page about a property. [https://www.w3.org/TR/wot-thing-description/#property-serialization-json](https://www.w3.org/TR/wot-thing-description/#property-serialization-json.). I think it's a little complicated. It means these structs are very different from tile, name and so on. It also means that these designs are very complex.

  Can I create an entity name Property and reference by an entity Thing? But how can I let the program know the Property is part of properties, not the Actions, also not the Events?

  I read the document again. There was new confusion. Why Properties everywhere?  Let’s see some examples: [https://www.w3.org/TR/2019/CR-wot-thing-description-20190516/#property-serialization-sample](https://www.w3.org/TR/2019/CR-wot-thing-description-20190516/#property-serialization-sample).

```
EXAMPLE 16 : Sample of Property serializations
...
"properties": {
    "on": {
        "type": "boolean",
        "forms": [...]
    },
    "status": {
        "type": "object",
        "properties": {
            "brightness": {
                "type": "number",
                "minimum": 0.0,
                "maximum": 100.0
                },
                "rgb": {
                "type": "array",
                "items" : {
                    "type" : "number",
                    "minimum": 0,
                    "maximum": 255
                },
                "minItems": 3,
                "maxItems": 3
            }
        },
        "required": ["brightness", "rgb"],
        "forms": [...]
    }
},
...

```

The ‘properties’ have a ‘status’ property, and then this ‘status’ has two ‘properties’? Let’s see another example:  [https://www.w3.org/TR/2019/CR-wot-thing-description-20190516/#action-serialization-sample](https://www.w3.org/TR/2019/CR-wot-thing-description-20190516/#action-serialization-sample)

```
EXAMPLE 17 : Sample of an Action serialization
...
"actions": {
    "fade" : {
        "title": "Fade in/out",
        "description": "Smooth fade in and out animation.",
        "input": {
            "type": "object",
            "properties": {
                "from": {
                    "type": "integer",
                    "minimum": 0,
                    "maximum": 100
                },
                "to": {
                    "type": "integer",
                    "minimum": 0,
                    "maximum": 100
                },
                "duration": {"type": "number"}
            },
            "required": ["to","duration"],
        },
        "output": {"type": "string"},
        "forms": [...]
    }
},
...
```

  The action ‘input’ has two ’properties’ ‘from’ and ‘to’. So, the property can just be the bundle of any entity design in Drupal? In this way, every entity can use property by an entity reference. But I still need to markup the property to ‘properties’.

  In the Friday morning, I discussed with the mentor. He inspires me. The [JSON:API](https://www.drupal.org/project/jsonapi) module exposes all the resources, but the one I need to complete exposes only the Thing resource. The final result of the discussion is I need to create two entity Thing and Property, and I can design the ‘action’ like the [JSON:RPC](https://www.drupal.org/project/jsonrpc)‘s actions. This approach was similar to what I expected, but just like the above question, I was unable to continue my work. After getting the mentor's reply, I had a lot of confidence to continue my work. So, I had copy content\_entity\_example from examples module, and rename to Thing and Property.

   The first task I got at this stage was my mentor ask to me write a controller like the JSON:API module. But JSON:API module doesn’t need to create an entity.

  The Thing may have multi-properties. When defining the field properties thereof thing should set Cardinality to be unlimited. Example: _modules/thing/src/Entity/Thing.php_

```
...
$fields['properties'] = BaseFieldDefinition::create('entity_reference')
  ->setCardinality(BaseFieldDefinition::CARDINALITY_UNLIMITED)
...

```

I still don't know how the actions of JSON:RPC work. The design of Events remains a problem. I will continue the following research.