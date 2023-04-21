xquery version "3.1";


module namespace config="https://jinntec.de/fore-exist/config";

(:~~
 : A list of regular expressions to check which external hosts are
 : allowed to access this TEI Publisher instance. The check is done
 : against the Origin header sent by the browser.
 :)
declare variable $config:origin-whitelist := (
    "(?:https?://localhost:.*|https?://127.0.0.1:.*)",
    "https?://unpkg.com",
    "https?://cdpn.io"
);

declare variable $config:page-root := "/db/apps/fore-exist/pages";




