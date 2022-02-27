---
title: "GSoC 2019 Coding Period Week 9"
date: 2019-07-28T08:59:21+00:00
draft: false
author: Loong
---

[//]: # ( UUID: 9236d472-a89c-450a-b0b4-c0eea0f657fb )
[//]: # ( Title: GSoC 2019 Coding Period Week 9 )
[//]: # ( Created: 2019-07-28T08:59:21+00:00 )

Answer the previous question mentioned in the [blog post](https://longxianwen.net/gsoc-2019-coding-period-week-4).

> How does type restrict the type of field that stores the property value?

Remove the `type` item in the Thing property type form. I've made some progress. I can get the information from a specific Thing property entity. It contains the field value and storage information. It means it doesn't need to fill out the value of `type` in the bundle of the Thing property type. Here are several data examples of interfaces that are consistent with the Web Thing specification.

Example: Get all things

_![things](/images/things_api.png)_

Example: Get a description of a Thing

![thing_desc](/images/thing_desc.png)

Property resource

> [3.3 Property resource](https://iot.mozilla.org/wot/#property-resource)
>
> A property resource represents a single property of a device. Some property resources may be read only and some may be writable. The value of a property can be retrieved with an HTTP GET request and updated with an HTTP PUT request.

Example: Get a property

![property_resource](/images/property_resource.png)

Properties resource

> [3.2 Properties resource](https://iot.mozilla.org/wot/#properties-resource)
>
> A properties resource represents all the properties of a device. The value of all properties can be retrieved with an HTTP GET request.

Example: Get all properties

![properties_resource](/images/properties_resource.png)