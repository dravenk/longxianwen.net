---
title: "GSoC 2019 Coding Period Week 8"
date: 2019-07-18T01:33:43+00:00
draft: false 
---

[//]: # ( UUID: b16ff53a-dd41-4277-8eb2-6c09d1084aac )
[//]: # ( Title: GSoC 2019 Coding Period Week 8 )
[//]: # ( Created: 2019-07-18T01:33:43+00:00 )

Since the [JSON:API](https://www.drupal.org/project/jsonapi) code base is very large, after copying the jsonapi module into the wotapi code base, I deleted a lot of things, such as the Query folder, but it was not enough. Cutting out the code base makes it easier for me to move forward.

![endpoint](/images/endpoint.png)

This is one endpoint of the jsonapi to the listing route to get a list of entities. All I need is a Thing Entity, and everything else is indexed to it based on a Thing Entity. The representation in the routing list is that the base path is _/things_.

I found that the earliest addition of base path _/jsonapi_ was at [Remove configurable 'prefix' + change the non-configurable prefix from '/api' to '/jsonapi'](https://www.drupal.org/project/jsonapi/issues/2838580). But prefix _/api_ added to the jsonapi code base in commit 54feb2f6eeb21bfefdaa0c61e45d629f12c1c5dd. I can't find any more discussion of the prefix. What worries me is: if there is no base path, will come up against duplication of route issue? I think I should keep prefix as this ensures won't come up duplication of route issues. But I need to change the _/jsonapi_ to _/wotapi_.

![pre](/images/pre.png)

The [JSON:API](https://www.drupal.org/project/jsonapi) generates the resource path by _/entity\_type\_id/bundle. See [getPath()](https://git.drupalcode.org/project/jsonapi/blob/8.x-2.x/src/ResourceType/ResourceType.php#L388)_

```
  /**
   * Get the resource path.
   *
   * @return string
   *   The path to access this resource type. Default: /entity_type_id/bundle.
   *
   * @see jsonapi.base_path
   */
  public function getPath() {
    return sprintf('/%s/%s', $this->getEntityTypeId(), $this->getBundle());
  }

```

There is no such thing as _/entity\_type\_id/bundle_ at [https://jsonapi.org](https://jsonapi.org/), so I need to find out why the jsonapi module is designed this way. And it is likely that the resource path of the _/entity\_type\_id/bundle_ design will still be used.

An example of a resource path on [https://jsonapi.org](https://jsonapi.org/):

![resource](/images/resource.png)

An example of a resource path on [https://iot.mozilla.org](https://iot.mozilla.org/wot/#web-thing-description):

![iotsource](/images/iotresource.png)

I found the record of _[getPath()](https://git.drupalcode.org/project/jsonapi/blob/8.x-2.x/src/ResourceType/ResourceType.php#L388)_ method at [Make the resource type aware of the resource path](https://www.drupal.org/node/2949635). But the actual design was: [[FEATURE] Move the resources to /{entity\_type\_id}/{bundle}/{id}](https://www.drupal.org/project/jsonapi/issues/2751525)

> In order to resolve [#2735665: [BUGFIX] Name collision with bundles with same name](https://www.drupal.org/project/jsonapi/issues/2735665 "Status: Closed (duplicate)") we need to move the bundle level resources namespaced under the entity type.

In fact, all we really need the entity type only Thing, so we're not going to have a bundle duplicate name problem. To make Things easier to read, I need to change the getPath() method. But what about other resources that might be referenced by Things?

```
public function getPath() {
  $entity_type_id = $this->getEntityTypeId();
  switch ($entity_type_id){
    case "wotapi_thing":
      return"/things";
    case "wotapi_property":
      return "/properties";
    default:
      return sprintf('/%s/%s', $entity_type_id, $this->getBundle());
  }
}
```

Access all Things resources:

![wotapi_things](/images/wotapi_things.png)

Get a single Thing resource:

![wotapi_thing](/images/wotapi_thing.png)

I need to change route behavior. The URL of obtaining Property resource described in the Web Thing API specification includes _/properties/_, but JOSNAPI obtaining relationships resource content is not included _/relationships._ I copy from JSONAPI to the [getIndividualRoutesForResourceType()](https://git.drupalcode.org/project/jsonapi/blob/8.x-2.x/src/Routing/Routes.php#L285) method, so I only need to change the part of this method can achieve a goal.

![properties_uri](/images/properties_uri.png)

After change [getIndividualRoutesForResourceType()](https://git.drupalcode.org/project/jsonapi/blob/8.x-2.x/src/Routing/Routes.php#L285) method. According to the current data, I can only get the name of the property from the URL.

![properties](/images/properties.png)

Based on the description of the ID, I'm going to get it from the URI.

```
\Drupal::request()->getUri()
```

![URL_ID](/images/url.png)

![ok2](/images/ok2.png)