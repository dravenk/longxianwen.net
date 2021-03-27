---
title: "GSoC 2019 Coding Period Week 7"
date: 2019-07-14T01:50:20+00:00
draft: false 
---

[//]: # ( UUID: b2b6c0ff-834a-418a-9d5a-abe93f1296dc )
[//]: # ( Title: GSoC 2019 Coding Period Week 7 )
[//]: # ( Created: 2019-07-14T01:50:20+00:00 )

As I mentioned in another [blog](https://longxianwen.net/gsoc-2019-coding-period-week-5), I can edit the value of Thing property when creating the Thing entity by [Inline Entity Form](https://www.drupal.org/project/inline_entity_form) (IEF).  After adding an Entity Reference type of field, commonly used WIDGET is Autocomplete/Autocomplete (tags style) instead of IEF. In the case of points, IEF is used by default after adding a field of entity reference type where the target type is points. So I need to refer to points to [implement hook\_entity\_presave()](https://git.drupalcode.org/project/points/blob/8.x-1.x/points.module#L81).

Fill in the label of the reference entity using Autocomplete (tags style):

![tags](/images/tags.png)

Edit a complete entity using [Inline Entity Form](https://www.drupal.org/project/inline_entity_form):

![points](/images/points.png)

Make sure that this button is checked when you add a Thing property field to the bundle of Thing type because Thing property did not exist before Thing was created:

![reference_type](/images/reference_type.png)

Setting default value cannot render when the WIDGET is set to [Inline Entity Form](https://www.drupal.org/project/inline_entity_form).

> Currently, in order to change the default value, I have to switch the widget to use a non-IEF widget, and then switch the widget back after saving. (see issue: [Widget doesn't render for setting default value](https://www.drupal.org/project/inline_entity_form/issues/3041572))

![tagss](/images/tagsss.png)

I created a bunch of predefined Thing property bundles. Maybe I need to create the predefined Thing type bundle according to [Capabilities](https://iot.mozilla.org/schemas/#capabilities). If I do this, it will make the consumer's ability to use this module much more useful. However, this approach will create a bundle of Thing type with a single capability. Another question, I don't think there's a good way for consumers not to edit certain values of entity reference fields. How to make 'read-only' uneditable while Motion value can still be editable in the value of MotionSensor?I found one comment in favor of not pre-defining Thing types:

> We're also finding that defining web thing types at just the thing level is too inflexible. Through the W3C we are investigating standardising "capabilities" - types of properties, actions and events which can be mixed and matched between devices. (See issue on GitHub [Get rid of the concrete Web Thing Types #56](https://github.com/mozilla-iot/wot/issues/56#issuecomment-365696298))

I searched for the [WOT](https://github.com/mozilla-iot/wot) specification project on GitHub for [read-only discussions](https://github.com/mozilla-iot/wot/issues?utf8=%E2%9C%93&q=read-only+). And another project on _[Read-only properties #1261](https://github.com/mozilla-iot/gateway/issues/1261)_. This discussion depends on [mozilla-iot/wot#38](https://github.com/mozilla-iot/wot/issues/38). Because predefined Thing types are not supported, the read-only attribute is not set to immutable on a certain Thing type. But it is still important to know how to use the read-only property. I found a good point about read-only properties.

> [https://github.com/mozilla-iot/wot/issues/38#issuecomment-313448788](https://github.com/mozilla-iot/wot/issues/38#issuecomment-313448788)
>
> I think that there are 2 very distinct concepts here.
>
> 1 - Whether a property is physically writable/modifiable or not.
>
> 2 - Whether a user is authorized to modify a modifiable property