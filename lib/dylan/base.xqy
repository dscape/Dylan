(:
 : Base functions for Dylan core
 :
 : Copyright (c) 2010 Nuno Job [about.nunojob.com]. All Rights Reserved.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :
 : The use of the Apache License does not indicate that this project is
 : affiliated with the Apache Software Foundation.
 :)
xquery version "1.0-ml";
module namespace d = "http://ns.dscape.org/2010/dylan/core";

import module namespace s = "http://ns.dscape.org/2010/dylan/string" 
  at "/lib/common/string.xqy" ;

declare variable $content-types :=
  ( "application/xhtml+xml", "application/xml" ) ;
declare variable $default-type  := "application/xml" ;

declare function d:render( $resource, $representation, $params ) {
  let $content-type   := d:content-type()
    let $format       := $content-type//d:ext
    let $template     := fn:lower-case( $template )
    let $http-code    := ( $params//d:http-code, 200 ) [1]
    let $description  := ( $params//d:description, "OK" ) [1]
    let $uri          := s:q( "/representations/$1/$2.$3.xqy", 
                                 ( $resource, $representation, $format ) )
    let $_ := xdmp:set-response-content-type( $content-type//text() )
    let $_ := xdmp:set-response-code( $http-code, $description )
    return xdmp:invoke( $uri, ( xs:QName( "params" ), 
             if( $params ) 
             then $params 
             else <d:empty/>),
             <options xmlns="xdmp:eval">
               <isolation>different-transaction</isolation>
               <prevent-deadlocks>true</prevent-deadlocks>
             </options> ) };

declare function d:content-type() {
  let $accept-types := fn:tokenize( fn:replace( 
      xdmp:get-request-header( "Accept" ), ";q=(\w|\.)+", "" ), "," )
    let $content-type  := 
      ( $content-types [ . = $accept-types ], $default-type ) [1]
    return <d:content-type>
             <d:ext> { fn:tokenize ( ( fn:tokenize( $content-type, "/" ) [2] ),
                                     "\+" ) [1] } </d:ext>
             { $content-type }
           </d:content-type> } ;

declare function d:error( $http-code, $description, $stack-trace ) {
  d:render( 'shared', 'error', <d:params>
    <d:http-code> { $http-code } </d:http-code>
    <d:description> { $description } </d:description>
    <d:stack-trace> { $stack-trace } </d:stack-trace> </d:params>) } ;

declare function d:request() {
  <d:options>
   <d:request>
     <d:header>
       <d:resource> { d:route() } </d:resource>
       { d:content-type() }
       <d:verb> { d:verb() } </d:verb>
       <d:client-address> 
         { xdmp:get-request-client-address() } </d:client-address>
       <d:timestamp> { fn:current-dateTime() } </d:timestamp>
       <d:http-headers>
         { for $f in xdmp:get-request-header-names()
           return let $sf := fn:lower-case( $f )
                  let $vf := xdmp:get-request-header( $f )
                  return element { fn:concat( "d:", $sf ) } 
                                 { $vf } }
       </d:http-headers>
    </d:header>
    <d:body>
      { for $f in xdmp:get-request-field-names()
        return element { fn:concat( "d:", fn:lower-case( $f ) ) } 
                       { xdmp:get-request-field( $f ) } }
    </d:body>
    </d:request>
  </d:options> } ;

declare function d:verb() { fn:lower-case( xdmp:get-request-method() ) } ;
declare function d:route() { xdmp:get-request-path() } ;

(: more for method missing :)
declare function d:action() { 
  fn:lower-case( xdmp:get-request-field( '_action' ) ) } ;
declare function d:resource() { 
  fn:lower-case( xdmp:get-request-field( '_resource' ) ) } ;
declare function d:id() { 
  fn:lower-case( xdmp:get-request-field( '_id' ) ) } ;
declare function d:function() { 
  fn:lower-case( xdmp:get-request-field( '_function' ) ) } ;
