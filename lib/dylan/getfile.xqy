xquery version "1.0-ml";

let   $uri       := xdmp:get-request-field( "_uri" )
  let $docformat := xdmp:uri-format( $uri ) 
  let $mimetype  := xdmp:uri-content-type( $uri ) 
  let $doc       := fn:doc($uri)
  return if ( $doc )
         then ( xdmp:set-response-content-type( $mimetype ), $doc )
         else ()
