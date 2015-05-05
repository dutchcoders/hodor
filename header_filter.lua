local whitelist_content_types = {
    "application/javascript",
    "application/x%-javascript",
    "application/pkix%-crl",
    "application/opensearchdescription%+xml",
    "application/x%-debian%-package"
}

-- disallowed content types
local blacklist_content_types = { 
    "application/.+" -- executables
}

function contains(val, list)
    for k, rule in pairs(list) do
        if (val:match(rule)) then
            return rule
        end
    end 

    return false
end

function content_type_filter(content_type, whitelist, blacklist)
    ngx.log(ngx.DEBUG, string.format("HONOS: Content type filter '%s'.", content_type))

    rule = contains(content_type, whitelist)
    if rule then
        ngx.log(ngx.DEBUG, string.format("HONOS: Explicitely allowed content type '%s' on white rule '%s'", content_type, rule))
    else
        rule = contains(content_type, blacklist) 
        if rule then
            ngx.log(ngx.INFO, string.format("HONOS: Blocked content-type '%s' on rule '%s'", content_type, rule))
            ngx.exit(ngx.HTTP_FORBIDDEN)
        end 
    end
end 

-- check content type header
local content_type = ngx.resp.get_headers()["Content-Type"]
content_type_filter(content_type, whitelist_content_types, blacklist_content_types)
