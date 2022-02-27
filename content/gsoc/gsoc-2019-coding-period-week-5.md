---
title: "GSoC 2019 Coding Period Week 5"
date: 2019-06-29T06:43:51+00:00
draft: false
author: Loong
---

[//]: # ( UUID: 31a50d58-8422-4fbd-81cd-5c34fded0e8b )
[//]: # ( Title: GSoC 2019 Coding Period Week 5 )
[//]: # ( Created: 2019-06-29T06:43:51+00:00 )

Last week, I try to show mentor the demo of property. So, I add a new field to the thing bundle. When the mentor saw that there was no Thing property to add a new field, he asked me: why is there no Thing property? I said Property is in Other of Reference category. But he said it should be shown on the outside, and I insisted there was no difference. Finally, of course, I need to research how to make the Property display on the Other... of Reference.  Because he thinks Property in Other... is hard to understand and also Thing property is easier to understand than Property. That's a reason to convince me.

At first, I thought I might need to implement a Field type myself. The first thing I did was implement a Field type according to [Creating a custom field](https://www.drupal.org/docs/8/creating-custom-modules/creating-custom-field-types-widgets-and-formatters/overview-creating). When I finished the project of example code, I felt that I was not right, or I misunderstood the meaning of the mentor. Because my original purpose of creating this field type was to create a Thing property when creating a Thing instance. However, this feature can be completely completed by using the [Inline entity form](https://www.drupal.org/project/inline_entity_form).  The example code on [Creating a custom field](https://www.drupal.org/docs/8/creating-custom-modules/creating-custom-field-types-widgets-and-formatters/overview-creating) is extended FieldItemBase, I need to create an EntityReference Field Type and I probably need extends EntityReferenceItem?

I did search the answer by Google: how to create an entity reference field type? Or `extends EntityReferenceItem`? Then I read an article. [Extending a Field Type in Drupal 8](https://www.lullabot.com/articles/extending-a-field-type-in-drupal-8). I copied the example code as a simple module.

```php
/**
 * @FieldType(
 *   id = "entity_reference_quantity",
 *   label = @Translation("Entity reference quantity"),
 *   description = @Translation("An entity field containing an entity reference with a quantity."),
 *   category = @Translation("Reference"),
 *   default_widget = "entity_reference_autocomplete",
 *   default_formatter = "entity_reference_label",
 *   list_class = "\Drupal\Core\Field\EntityReferenceFieldItemList",
 * )
 */
class EntityReferenceQuantity extends EntityReferenceItem {}
```

I get something like this.

![quantily](/images/quantity.png)

I don't know why Content, User, Taxonomy term is displayed twice. Maybe it's because of incomplete code. But even though I created the FieldWidget and FieldFormatter as an example, it still doesn't change the display here, maybe the example code was created too long ago, and some interface behavior has changed. Not only that but if I implement a field type myself, I won't be able to use Entity Reference's FieldWidget and FieldFormatter any more. If I don't create a FieldWidget, I won't be able to use it.

.![fieldwidget123](/images/123.png)

What makes me most curious about the example pictures is why the three options of Content, User, Taxonomy term are different from file and image. I spent a lot of time looking for similarities and differences. I use [xdebug](https://xdebug.org/) to find the information I want.

![1222](/images/1222_0.png)

I see what this method does.

```php
/**
 * Indicates whether this entity type is commonly used as a reference target.
 *
 * @return bool
 *   TRUE if the entity type is a common reference; FALSE otherwise.
 */
public function isCommonReferenceTarget();
```

And found very important information.

```php
/**
 * Indicates whether this entity type is commonly used as a reference target.
 *
 * This is used by the Entity reference field to promote an entity type in the
 * add new field select list in Field UI.
 *
 * @var bool
 */
protected $common_reference_target = FALSE;
```

![001](/images/001.png)

![002](/images/002.png)

![003](/images/003.png)

This is why they appear on Reference the top of 'Other...'. I added this line of code to the code @ContentEntityType().

```php
common_reference_target = TRUE
```

I don't have to create a Field type. The effect looks something like this.

![thing-property](/images/thing-property.png)

We also discussed whether Thing property should be hard-coded. To do this, I have to find a file like IETF RFC. Because it will use key words "MUST", "MUST NOT", "REQUIRED"... More accurately inform what implementations need to be done. So I created an issue [Define which members are mandatory vs. optional](https://github.com/mozilla-iot/wot/issues/135) for the wot project on github.com.The [reply](https://github.com/mozilla-iot/wot/issues/135#issuecomment-507314134) from the maintainers of the wot specification is:

> I'm afraid the unofficial specification we maintain at https://iot.mozilla.org/wot does not yet have these kinds of formal definitions like an IETF RFC might have, although we should probably at least specify which members are mandatory (I've updated the title of this issue to reflect that).
