# honos: nginx proxy filtering

Honos is a library allowing you to filter on host, uri or content-type. 

## Todo

* implement geo blocking
* implement antivirus / clamav
* implement dnsbl lists
* implement client ip specific blocking
* seperate configuration from logic
* define complex rules

## Implementation

Update the nginx.conf

```
lua_shared_dict my_locks 100k;
lua_package_path "lua/?.lua;../lua-resty-core/lib/?.lua;;";

resolver 8.8.8.8;

init_by_lua '
';

server {
    listen       0.0.0.0:80;
    server_name  _;

    header_filter_by_lua_file 'header_filter.lua';
    access_by_lua_file 'access.lua';

    location / {
        proxy_ssl_verify off;
        proxy_pass_header Server;
        proxy_set_header Host $host;
        proxy_pass http://$host:80;
    }
}
```


Reloading the rules

```
kill -HUP $( cat /usr/local/openresty/nginx/logs/nginx.pid )
```

## Contributions

Contributions are welcome.

## Creators

**Remco Verhoef**
- <https://twitter.com/remco_verhoef>
- <https://twitter.com/dutchcoders>

## Copyright and license

Code and documentation copyright 2011-2015 Remco Verhoef.

Code released under [the MIT license](LICENSE).
