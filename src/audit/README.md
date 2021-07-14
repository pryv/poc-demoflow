# audit

> Audit Demo

## Build Setup

``` bash
# install dependencies
yarn install

# serve dev app at:
# localhost:8080/#/?username=USERNAME&auth=TOKEN&serviceInfoUrl=SERVICE_INFO_URL
yarn run dev

# build for production with minification
yarn run build

# build for production and view the bundle analyzer report
yarn run build --report
```

For a detailed explanation on how things work, check out the [guide](http://vuejs-templates.github.io/webpack/) and [docs for vue-loader](http://vuejs.github.io/vue-loader).

### Use rec.la proxy: 
```
npm install rec-la -g
rec-la-proxy localhost:8081 8082
```

open https://l.rec.la:8081