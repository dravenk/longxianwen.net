---
title: "GSoC 2019 Coding Period Week 13"
date: 2019-08-25T06:46:17+00:00
draft: false 
---

[//]: # ( UUID: 8941f957-8c13-40cf-a732-f0058c53f0bc )
[//]: # ( Title: GSoC 2019 Coding Period Week 13 )
[//]: # ( Created: 2019-08-25T06:46:17+00:00 )

I made a video tutorial [Build a Web of Things project using the WoT:API module](https://www.youtube.com/watch?v=_sYx9WVeL-8&t=1s). This video contains the entire process from enabling the module to lighting the LED. The main demonstration content is as follows:

- Download the WoT:API module using composer


    ```
     composer require 'drupal/wotapi:1.x-dev' -vvv
    ```

- Enable all modules of the WOTAPI package.
- Add thing type: Lamp
- Manage fields >> Add field >> Thing property：Switch.


     check: Create referenced entities if they don't already exist.


     check: OnOffProperty
- Manage fields >> Add field >> Thing action: Toggle
- Download the sandbox project Action example. This sandbox is not available for download by the composer, so use git clone to download it:


    ```
    git clone https://git.drupalcode.org/sandbox/dravenk-3075952.git modules/custom/action_example
    ```

- Download the dependency package for the sandbox project:


    ```
    composer require ronanguilloux/php-gpio -vvv
    ```

- Back to the Toggle field management page of Lamp:


     Check default value: toggle
- Back to Structure >> Things >> Thing list >> add Thing: LampA >> Save
- Open _{site}/wotapi/things/_, You can see the thing output of the json data
- Copy the actions href of the links object.
- Open the Postman:


     Request method:  POST


     Request URL:  {site}/actions


     Authorization:  Basic Auth


     Content-Type: application/json


     Body:   '{"toggle":{}}'
- Enable the basic\_auth module
- Insert the LED light in the position where the pin value is 17 in the raspberry pi. This [blog](https://longxianwen.net/gsoc-2019-coding-period-week-12) has more information.
- Click Postman Send to send the request.