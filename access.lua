local whitelist_uris = {
}

local blacklist_uris = {
    "porn" -- will block all uri's containing porn
    -- ".*" -- block all
}

local whitelist_hosts = {
    "www.microsoft.com"
}

local blacklist_hosts = {
    ".*"
}

ngx.req.read_body()

function contains(val, list)
    for k, rule in pairs(list) do
        if (val:match(rule)) then
            return rule
        end
    end 

    return false
end

function host_filter(host, whitelist, blacklist) 
    ngx.log(ngx.DEBUG, string.format("HONOS: Host filter '%s'.", host))

    rule = contains(host, whitelist)
    if rule then
        ngx.log(ngx.DEBUG, string.format("HONOS: Explicitely allowed host '%s' on white rule '%s'", host, rule))
    else
        rule = contains(host, blacklist) 
        if rule then
            ngx.log(ngx.INFO, string.format("HONOS: Blocked host '%s' on rule '%s'", host, rule))
            ngx.exit(ngx.HTTP_FORBIDDEN)
        end 
    end
end 

function uri_filter(uri, whitelist, blacklist)
    ngx.log(ngx.DEBUG, string.format("HONOS: Uri filter '%s'.", uri))

    rule = contains(uri, whitelist)
    if rule then
        ngx.log(ngx.DEBUG, string.format("HONOS: Explicitely allowed uri '%s' on white rule '%s'", uri, rule))
    else
        rule = contains(uri, blacklist) 
        if rule then
            ngx.log(ngx.INFO, string.format("HONOS: Blocked uri '%s' on rule '%s'", uri, rule))
            ngx.exit(ngx.HTTP_FORBIDDEN)
        end 
    end
end 

uri_filter(ngx.var.uri, whitelist_uris, blacklist_uris)

host_filter(ngx.var.host, whitelist_hosts, blacklist_hosts)

