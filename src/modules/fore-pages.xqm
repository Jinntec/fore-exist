xquery version "3.1";

module namespace fp="https://jinntec.de/fore-exist";

import module namespace config="https://jinntec.de/fore-exist/config" at 'config.xqm';
import module namespace roaster="http://e-editiones.org/roaster";

declare function fp:save-page($request as map(*)){
    let $user := sm:id()//sm:real/sm:username/string()
    let $collection := $request?parameters?collection
    let $resourceName := $request?parameters?filename
    let $payload := $request?body/node()
    let $stored := xmldb:store($config:page-root, $resourceName || '.html' , $payload)
    return <stored>{$stored}</stored>
};
declare function fp:save-todos($request as map(*)){
    let $user := sm:id()//sm:real/sm:username/string()
    let $collection := $request?parameters?collection
    let $payload := $request?body/node()
    let $stored := xmldb:store($config:page-root, $user || '-todos.xml' , $payload)
    return <stored>{$stored}</stored>
};

declare function fp:load-page($request as map(*)){
    let $user := sm:id()//sm:real/sm:username/string()
    let $stored := collection($config:page-root)//data[@user=$user]//task
    return <data user="{$user}">{$stored}</data>
};

declare function fp:escape-client-name($input  as xs:string?){
    let $replace1 := replace(data($input),' ','-')
    let $replace2 := replace($replace1,',','')
    let $replace3 := replace($replace2,'\.','')
    return $replace3
};
