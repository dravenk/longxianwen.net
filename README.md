Beian

```
git clone git@github.com:dravenk/longxianwen.net.git
cd longxianwen.net
docker run --rm -d --name loong -p 1313:1313 \
  -v ${PWD}:/src \
  hugomods/hugo \
  hugo server --bind 0.0.0.0
```


```
git submodule update --init
```


```
docker run --rm  -v ${PWD}:/src  hugomods/hugo hugo
```