---
title: "Use Golang to parse non-standard custom time strings as Time type"
date: 2022-03-23T13:45:46+08:00
draft: true
---

Today, when interconnecting with a colleague interface, the time format defined by a colleague needs to be resolved to a standardized time format.
Checkout [time#pkg-constants](https://pkg.go.dev/time#pkg-constants) know more about golang time format.

Go to [The Go Playground](https://go.dev/play/) to run.

```go
package main

import (
  "fmt"
  "time"
)

// 2020-09-16 11:00:00
func parseCustomTime(timeString string) (time.Time, error) {
  SH, _ := time.LoadLocation("Asia/Shanghai")
  const customLayout = "2006-01-02 15:04:05"
  t, err := time.ParseInLocation(customLayout, timeString, SH)
  return t, err
}

func main() {
  timeString := "2020-09-16 11:00:00"
  t, _ := parseCustomTime(timeString)
  fmt.Println(t)

  tt, err := parseCustomTime("")
  if err != nil {
    fmt.Println("time: ", tt, "| Error: ", err)
  } else {
    fmt.Println(tt)
  }
}

```
