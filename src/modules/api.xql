xquery version "3.1";

declare namespace api="http://e-editiones.org/real-time/test-api";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

import module namespace roaster="http://e-editiones.org/roaster";

import module namespace rutil="http://e-editiones.org/roaster/util";
import module namespace errors="http://e-editiones.org/roaster/errors";
import module namespace auth="http://e-editiones.org/roaster/auth";
import module namespace router="http://e-editiones.org/roaster/router";

import module namespace fp="https://jinntec.de/fore-exist" at "fore-pages.xqm";
import module namespace todo="https://jinntec.de/fore-exist/todo" at "todo.xqm";



(:~
 : list of definition files to use
 :)
declare variable $api:definitions := ("api.json");


(:~
 : You can add application specific route handlers here.
 : Having them in imported modules is preferred.
 :)

declare function api:date($request as map(*)) {
    $request?parameters?date instance of xs:date and
    $request?parameters?dateTime instance of xs:dateTime
};

(:~
 : An example how to throw a dynamic custom error (error:NOT_FOUND_404)
 : This error is handled in the router
 :)
declare function api:error-triggered($request as map(*)) {
    error($errors:NOT_FOUND, "document not found", "error details")
};

(:~
 : calling this function will throw dynamic XQuery error (err:XPST0003)
 :)
declare function api:error-dynamic($request as map(*)) {
    util:eval('1 + $undefined')
};

(:~
 : Handlers can also respond with an error directly 
 :)
declare function api:error-explicit($request as map(*)) {
    roaster:response(403, "application/xml", <forbidden/>)
};

(:~
 : This is used as an error-handler in the API definition 
 :)
declare function api:handle-error($error as map(*)) as element(html) {
    <html>
        <body>
            <h1>Error [{$error?code}]</h1>
            <p>{
                if (map:contains($error, "module"))
                then ``[An error occurred in `{$error?module}` at line `{$error?line}`, column `{$error?column}`]``
                else "An error occurred!"
            }</p>
            <h2>Description</h2>
            <p>{$error?description}</p>
        </body>
    </html>
};

declare function api:binary-upload ($request as map(*)) {
    let $stored := xmldb:store("/db/apps/real-time", $request?parameters?path, $request?body)
    return roaster:response(201, $stored)
};

declare function api:binary-load($request as map(*)) {
    if (util:binary-doc-available("/db/apps/real-time/" || $request?parameters?path))
    then (
        util:binary-doc("/db/apps/real-time/" || $request?parameters?path)
        => response:stream-binary("application/octet-stream", $request?parameters?path)
    )
    else (
        error($errors:NOT_FOUND, "document " || $request?parameters?path || " not found", "error details")
    )
};


(: end of route handlers :)

(:~
 : This function "knows" all modules and their functions
 : that are imported here 
 : You can leave it as it is, but it has to be here
 :)
declare function api:lookup ($name as xs:string) {
    function-lookup(xs:QName($name), 1)
};

roaster:route($api:definitions, api:lookup#1)
