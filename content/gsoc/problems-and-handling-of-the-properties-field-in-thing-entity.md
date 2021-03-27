---
title: "Problems and handling of the properties field in Thing entity"
date: 2019-06-17T15:21:35+00:00
draft: false 
---

[//]: # ( UUID: f9048e80-b2f6-4cce-a413-8b1e16faaff6 )
[//]: # ( Title: Problems and handling of the properties field in Thing entity )
[//]: # ( Created: 2019-06-17T15:21:35+00:00 )

After I changed the Property entity and Thing entity to support bundles last week, I had a problem. When I created a thing, I couldn't add a property by Autocomplete.

I then add properties when I create a thing. It's going to look something like below, it doesn't show the property that I've created for me to select.

![1233](/images/123321.png)

This is the definition of the properties field in the screenshot:

```
Drupal\wotapi_thing\Entity
...
public static function baseFieldDefinitions(EntityTypeInterface $entity_type) {
...
// Owner property of the thing.
$fields['properties'] = BaseFieldDefinition::create('entity_reference')
  ->setLabel(t('Property'))
  ->setDescription(t('The Property.'))
  ->setSetting('target_type', 'wotapi_property')
  ->setSetting('handler', 'default')
  ->setDisplayOptions('view', [
    'label' => 'above',
    'type' => 'wotapi_property',
    'weight' => -3,
  ])
  ->setDisplayOptions('form', [
    'type' => 'entity_reference_autocomplete',
    'settings' => [
      'match_operator' => 'CONTAINS',
      'size' => 60,
      'placeholder' => '',
    ],
    'weight' => -3,
  ])
  ->setCardinality(BaseFieldDefinition::CARDINALITY_UNLIMITED)
  ->setDisplayConfigurable('form', TRUE)
  ->setDisplayConfigurable('view', TRUE);
...
}

```

So I am thinking: user and tag in the Article are also referenced, and Autocomplete works very well, why is it not displayed here? I guess the baseFieldDefinitions method in Drupal\\wotapi\_thing\\Entity\\Thing is incorrectly written? Is the definition of properties correct for Thing.php?After I checked the document, I made sure it was correct. I continued to use Google to search for relevant information: **drupal 8 custom entity reference**. Then I found out that someone had the [same problem](https://drupal.stackexchange.com/questions/211721/how-to-create-entity-reference-field-from-custom-entity-to-another-custom-entity?answertab=votes#tab-top) as me. I forgot the following important line.

```
entity_keys = {
  "label" = "title",
},
```

Since the base field used by the [property object](https://iot.mozilla.org/wot/#property-object) is title instead of label or name, I need to put "label" = "title" in the annotation @contententitytype of the property entity. I found a very easy explanation [here](https://drupal.stackexchange.com/questions/194316/what-is-the-purpose-of-entity-keys-in-contententitybase). That makes me even more impressed.

> entity\_keys are basically an alias for fields. It allows generic code, like the storage backends, to access common fields that have different names, for example the ID. They need write the saved value, so the can't just use id() as most places.

This is an example of the documentation that I want to do.

```
  "properties": {
    "on": {
      "@type": "OnOffProperty",
      "type": "boolean",
      "description": "Whether the lamp is turned on",
      "href": "/things/lamp/properties/on"
    },
    "brightness": {
      "@type": "BrightnessProperty",
      "type": "integer",
      "description": "The level of light from 0-100",
      "minimum": 0,
      "maximum": 100,
      "href": "/things/lamp/properties/brightness"
    }
  }

```

In fact, the property I got this week is still properties without detailed content. Here's what I got :

```
  "properties": {
    "a4a1bb77-0e02-453d-958a-c898d112116a": {
      "type": "wotapi_property--boolean",
      "id": "a4a1bb77-0e02-453d-958a-c898d112116a"
    },
    "9a1c9141-e176-4da6-a4d4-8560a54dccb3": {
      "type": "wotapi_property--integer",
      "id": "9a1c9141-e176-4da6-a4d4-8560a54dccb3"
    },
    "links": [
      {
        "href": "http://dp.localhost/wotapi/wotapi_thing/light/33558c4a-f567-4d31-836e-c2ac5b166032/properties"
      }
    ]
  }

```

I really want to export the property resource as described in the document, but I have a lot of Normalizer code coming from [JSON:API](https://www.drupal.org/project/jsonapi), and there are still a lot of things I don't understand about the entity reference field related processing code. For example, [ResourceIdentifierNormalizer.php#L53](https://git.drupalcode.org/project/jsonapi/blob/8.x-2.x/src/Normalizer/ResourceIdentifierNormalizer.php#L53), I need to normalize the entity containing the reference field only type and id. How do I get all the details of the reference field before the entity is normalized, such as title and description contained in the reference field?

![ResourceIdentifierNormalizer](/images/what23.png)

Or, [ResourceObjectNormalizer.php#L66](https://git.drupalcode.org/project/jsonapi/blob/8.x-2.x/src/Normalizer/ResourceObjectNormalizer.php#L66) for the relationship in ResourceObjectNormalizer field according to the existing type and id Find the corresponding entity resource and serialize it completely?

Details of properties are now available through links. Can this problem be postponed for the time being, and will there be any inspiration to deal with it when considering the implementation of actions?