xquery version "1.0-ml";

declare variable $params as node() external;

declare function local:maincol(){
  <div id="main"> { for $status in fn:doc() /status [1 to 10]
    return xdmp:invoke( '_status.xqy', ( fn:QName( "", "status" ) , $status), () ) }
  </div> } ;

declare function local:title() {
  'Alive :D' } ;


let $sections := map:map()
let $_     := for $f in ( 'maincol', 'title' )
              return map:put( $sections, $f, xdmp:apply( xdmp:function( xs:QName(
                fn:concat( "local:", $f ) ) ) ) )
return $sections