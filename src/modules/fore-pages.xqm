xquery version "3.1";

module namespace fp="https://jinntec.de/fore-exist";

import module namespace config="https://jinntec.de/fore-exist/config" at 'config.xqm';
import module namespace roaster="http://e-editiones.org/roaster";

declare function fp:save-page($request as map(*)){
    let $filename := $request?parameters?filename
    let $collection := $request?parameters?collection
    let $payload := $request?body/node()
    let $client-resource-name := fp:escape-client-name($filename)
    let $stored := xmldb:store($config:page-root, $filename || ".html" , $payload)

    return <stored>{$stored}</stored>


};

declare function fp:escape-client-name($input  as xs:string?){
    let $replace1 := replace(data($input),' ','-')
    let $replace2 := replace($replace1,',','')
    let $replace3 := replace($replace2,'\.','')
    return $replace3
};
