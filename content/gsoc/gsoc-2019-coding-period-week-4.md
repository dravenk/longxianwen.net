---
title: "GSoC 2019 Coding Period Week 4"
date: 2019-06-21T03:45:03+00:00
draft: false 
---

[//]: # ( UUID: 4bdd07c1-97c9-4336-97f2-3b05f0b2c6b6 )
[//]: # ( Title: GSoC 2019 Coding Period Week 4 )
[//]: # ( Created: 2019-06-21T03:45:03+00:00 )

I made a mistake last week. Thanks so much for the mentor pointing out my mistake. I filled in the wrong data in the screenshot of the blog for testing. The mentor found the problem after reading, and we spent a long time discussing related content. I placed the field that should be defined on the property entity incorrectly on the property bundle.

Take the JSONAPI example again. Relationships under Entity contain the type and ID information of the related Entity, but not the storage information of the related Entity. You can view the stored information either through a query of the JSONAPI or through a link given in related.

![21333](/images/1233.png)

Click on the href to get the storage information of the related entity.

![123333](/images/1222.png)

The [Thing resource](https://iot.mozilla.org/wot/#thing-resource) example in the [Web Thing API](https://iot.mozilla.org/wot) looks like this.

![222](/images/222_0.png)

Get the detailed value of properties

![3333](/images/3333.png)

I discussed this problem with mentor again. The result of our discussion is that: Thing entity refers to multiple property fields by way of entity reference, and the value of Properties is filled in when creating a Thing.

As for the type of [property-object](https://iot.mozilla.org/wot/#property-object), follow the document description.

> A primitive `type` (one of null, boolean, object, array, number, integer or string as per [[json-schema](https://iot.mozilla.org/wot/#bib-json-schema)])

> [3.5.  JSON Schema primitive types](https://tools.ietf.org/html/draft-zyp-json-schema-04#section-3.5)
>
>    JSON Schema defines seven primitive types for JSON values:
>
>    array  A JSON array.
>
>    boolean  A JSON boolean.
>
>    integer  A JSON number without a fraction or exponent part.
>
>    number  Any JSON number.  Number includes integer.
>
>    null  The JSON null value.
>
>    object  A JSON object.
>
>    string  A JSON string.

There are other questions:

- Since Property Type allows multiple bundles and arbitrary fields to be added, which field is used to store the value of the Property?
- What is the field name that specifies the value to store the Property?
- How does type restrict the type of field that stores the property value?
- By dynamically adding fields when creating bundles? Like this: [https://git.drupalcode.org/project/points/blob/8.x-1.x/src/Form/PointTypeForm.php#L54](https://git.drupalcode.org/project/points/blob/8.x-1.x/src/Form/PointTypeForm.php#L54)
- If type is an object, how define the type of field in the Property bundle?

We discussed these issues again face to face. Many of these problems were due to user interface confusion, but I needed to prioritize better data structures. I will [Create a custom field](https://www.drupal.org/docs/8/creating-custom-modules/creating-custom-field-types-widgets-and-formatters/overview-creating) according to the document description.  It will look like the following directory structure, which I'm still working on.

![fieldtype](/images/010101.png)