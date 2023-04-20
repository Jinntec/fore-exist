xquery version "3.1";


let $spec := collection('/db/apps/fore-exist/data')//attribute
return
    distinct-values($spec)


