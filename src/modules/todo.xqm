xquery version "3.1";

module namespace todo="https://jinntec.de/fore-exist/todo";

import module namespace config="https://jinntec.de/fore-exist/config" at 'config.xqm';
import module namespace roaster="http://e-editiones.org/roaster";

declare function todo:save-todos($request as map(*)){
    let $user := sm:id()//sm:real/sm:username/string()
    let $collection := $request?parameters?collection
    let $payload := $request?body/node()
    let $stored := xmldb:store($config:page-root, $user || '-todos.xml' , $payload)
    return <stored>{$stored}</stored>
};

declare function todo:load-todos($request as map(*)){
    let $user := sm:id()//sm:real/sm:username/string()
    let $stored := collection($config:page-root)//data[@user=$user]//task
    return <data user="{$user}">{$stored}</data>
};

