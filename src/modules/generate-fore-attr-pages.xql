xquery version "3.1";

declare option exist:serialize "method=html5 media-type=text/html";



declare function local:get-control($attr){
    switch($attr)
        case "defaultaction" return
            <fx-control ref="{$attr}">
                <select id="{$attr}" class="widget">
                    <option>perform</option>
                    <option>cancel</option>
                </select>
            </fx-control>
        case "delay" return
            <fx-control ref="{$attr}">
                <input id="{$attr}" type="number"/>
            </fx-control>
        case "phase" return
            <fx-control ref="{$attr}">
                <select id="{$attr}" class="widget">
                    <option>default</option>
                    <option>capture</option>
                </select>
            </fx-control>
        case "propagate" return
            <fx-control ref="{$attr}">
                <select id="{$attr}" class="widget">
                    <option>continue</option>
                    <option>stop</option>
                </select>
            </fx-control>
        case "target" return
            <fx-control ref="{$attr}">
                <input list="{$attr}-list"/>
                <datalist id="{$attr}-list" data-ref="get-targets()">
                    <template>
                        <option>{{.}}</option>
                    </template>
                </datalist>
            </fx-control>
        default return
            <fx-control id="{$attr}" ref="{$attr}">
                <label>{$attr}</label>
            </fx-control>
};


let $spec := collection('/db/apps/fore-exist/data')//elements
let $out :=
    for $element in $spec/element
        let $name := string($element/name)
        let $attrs := $element/attributes/attribute
        let $props := $element/properties/property
        let $fore-element :=
                    <fx-fore id="{$name}">
                        <fx-model>
                            <fx-instance>
                                <data>
                                {
                                    for $attr in $attrs
                                        let $attr-name := lower-case($attr/name/string())
                                        return element{$attr-name}{' '}
                                }
                                </data>
                            </fx-instance>
                            <fx-function signature="get-targets()  as element()*">
                                return document.querySelectorAll('[id]');
                            </fx-function>
                        </fx-model>
                        <table>
                            <caption>Attributes</caption>
                            {
                                for $attr in $attrs
                                let $a := lower-case($attr/name/string())
                                return
                                    <tr>
                                        <td>
                                            <label for="{$a}">{$a}</label>
                                        </td>
                                        <td>{local:get-control($a)}</td>
                                    </tr>
                            }
                        </table>
                    </fx-fore>

        return
           xmldb:store("/db/apps/fore-exist/data" , $name || ".html", $fore-element)



return
    <data>
        {$out}
    </data>



