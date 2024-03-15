---
title: "Instead of using drush sqlc to import data, use drush sql:connect"
date: 2024-01-04T21:05:28+08:00
draft: false
author: Loong
tag: post
---


I've developed a lot of websites and applications using drupal, and in general I've used gzip and drush to import databases. When a database is more than 500M long, it usually takes ten minutes or even half an hour to import data into the database using `gzip -c xx.sql.gz | drush sqlc`.

Today, when I was importing a data package to the drupal website, I think the long execution time unbearable to me. So I investigated more efficient ways. I investigated the multi-threaded decompression scheme of `gzip` and finally decided to use [`pigz`](https://zlib.net/pigz/) instead of gzip to decompress packets.

> pigz, which stands for parallel implementation of gzip, is a fully functional replacement for gzip that exploits multiple processors and multiple cores to the hilt when compressing data.

In the process of decompress and importing data into the database, the data I tested showed that `pigz` and `gzip`. After I do some investigation and testing, I found that using `drush sql-connect` to import data is many times faster than using `drush sqlc`

The command in below is executes very slowly.
```
time gunzip -c /tmp/test.gz | pv | drush sqlc
```

The command in below is fast then above.
```
time gunzip -c /tmp/test.gz | pv | $(drush sql-connect)
```

Machine for testing.
![system-info.png](/images/system-info.png)

Look at the test results below.
![opp-architechure](/images/drush-sql-test.png)

