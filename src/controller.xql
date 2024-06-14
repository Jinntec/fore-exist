xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

if ($exist:path eq "") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>

(: forward root path to index.xql :)
else if ($exist:path eq "/") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="index.html"/>
    </dispatch>

else if(ends-with($exist:path,'.html')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/{$exist:path}">
            <set-header name="Cache-Control" value="no-cache"/>
        </forward>
    </dispatch>

else if(starts-with($exist:path, "/doc")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/{$exist:path}">
            <set-header name="Cache-Control" value="max-age=31536000"/>
        </forward>
    </dispatch>
else if(starts-with($exist:path, "/demo")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/{$exist:path}">
            <set-header name="Cache-Control" value="max-age=31536000"/>
        </forward>
    </dispatch>
else if(starts-with($exist:path, "/resources")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/{$exist:path}">
            <set-header name="Cache-Control" value="max-age=31536000"/>
        </forward>
    </dispatch>
else if(starts-with($exist:path, "/pages")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/{$exist:path}">
            <set-header name="Cache-Control" value="no-cache"/>
        </forward>
    </dispatch>

(: static HTML page for API documentation should be served directly to make sure it is always accessible :)
else if ($exist:path = ("/api.html","/api.json", "/index.html")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
    </dispatch>

(: other images are resolved against the data collection and also returned directly :)
else if (matches($exist:resource, "\.(png|jpg|jpeg|gif|tif|tiff|txt|mei|xml)$", "s")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/{$exist:path}">
            <set-header name="Cache-Control" value="max-age=31536000"/>
        </forward>
    </dispatch>
else if (ends-with($exist:path, '.xml')) then
    <forward url="{$exist:controller}/{$exist:path}">
        <set-header name="Cache-Control" value="no-cache"/>
    </forward>

(: use a different Open API router, needs exist-jwt installed! :)
else if (starts-with($exist:path, '/jwt')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/custom-router.xq">
            <set-header name="Access-Control-Allow-Origin" value="*"/>
            <set-header name="Access-Control-Allow-Credentials" value="true"/>
            <set-header name="Access-Control-Allow-Methods" value="GET, POST, DELETE, PUT, PATCH, OPTIONS"/>
            <set-header name="Access-Control-Allow-Headers" value="Accept, Content-Type, Authorization, X-Auth-Token"/>
            <set-header name="Cache-Control" value="no-cache"/>
        </forward>
    </dispatch>

(: all other requests are passed on the Open API router :)
else
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/api.xql">
            <set-header name="Access-Control-Allow-Origin" value="*"/>
            <set-header name="Access-Control-Allow-Credentials" value="true"/>
            <set-header name="Access-Control-Allow-Methods" value="GET, POST, DELETE, PUT, PATCH, OPTIONS"/>
            <set-header name="Access-Control-Allow-Headers" value="Accept, Content-Type, Authorization, X-Start"/>
            <set-header name="Cache-Control" value="no-cache"/>
        </forward>
    </dispatch>