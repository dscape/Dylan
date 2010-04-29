xquery version "1.0-ml";

declare variable $params as node() external;

(: and idea is to change other templates to be based on xml
   and created with xslt? Maybe a generic templating engine
    that allows pluggable :)

'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
                       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title> { fn:string( $params//*:http-code ) } 
            - { fn:string( $params//*:description ) } </title>
  </head>
  <body>
    <div class="error" id="error#{ $params//*:http-code }">
      <div id="description">
        { fn:string( $params//*:description ) }
      </div>
      <div id="timestamp"> { fn:string( $params//*:timestamp ) } </div>
      <div id="stacktrace"> { fn:string( $params//*:stack-trace ) } </div>
    </div>
  </body>
</html>
