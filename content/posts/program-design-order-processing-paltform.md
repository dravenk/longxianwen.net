---
title: "Developed an Order Processing Platform for the company to process millions of orders"
date: 2022-02-27T17:09:21+08:00
summary: "I design an Order Processing Platform for one hundred people compony, when I was a junior student."
draft: false
author: Loong
tag: post
---

Today I looked at the code I wrote before. I design an Order Processing Platform (OPP) for a compony, when I was a junior student. In fact, I seldom go to school. The system efficiently processed millions of commercial orders. I gonna tell you some story about this system.

### OPP Architecture

![opp-architechure](/images/opp.png)

**This project included there main features on the follow.**

* Concurrency control
* Horizontal scaling
* Couchdb monitored, real-time order push
* Convert the source orders into subsystem identifiable orders.
* Cronjob statistical and repair
* Verify order correctness and email notification
* Processed synchronously in multiple systems
* Processed asynchronously in multiple systems
* Data interface, easy integration to other systems
* Command line tool

### Directory struct

![opp-directory-struct](/images/opp-dir.png)

Initially, the system was developed by [Node.js](https://nodejs.org/) and its feature was to listening to CouchDB and push orders to the company order center (OC). When I started as a project lead, I maintained it for a short time. The processing speed was overwhelming. Synchronizing ten thousand orders can take few hours to a whole day. At that time there were multiple merchant database, not concurrently processing, all merchant orders as a polling. But the system has a nice feature, such as a nice system interface.

Later, with the approval of the leader, I began to rebuild the system as project leader. After asking the leader's opinion, the system does not need a beautiful interface, but needs to process orders efficiently. I decided to redevelop it using the [Go](https://golang.org/) language.
