xquery version "1.0-ml" ;
module  namespace r = "http://ns.dscape.org/2010/dylan/cfg/routes" ;
declare namespace d = "http://ns.dscape.org/2010/dylan/core" ;
declare namespace s = "http://www.w3.org/2009/xpath-functions/analyze-string" ;

import module 
  namespace c = "http://ns.dscape.org/2010/dylan/cache"
  at "/lib/common/cache.xqy";

declare variable $routes :=
<routes xmlns="http://ns.dscape.org/2010/dylan/core">
  <resource name="user"/>
  <resource name="status">
    <include action="public"/>
  </resource>
  <match path="/twitter">
    <redirect_to> http://www.twitter.com </redirect_to>
  </match>
  <match path="/logout"> <to> sessions#delete </to> </match>
  <match path="/login"> <to> sessions#post </to> </match>
  <match path="/activate/:key"> <to> user#activate </to> </match>
  <root> status#list </root> 
  <match path="/:resource/:function/:id"/>
<!-- Other useful to know defaults:
  - /images/
  - /css/
  - /js/
  - /db/

  Dont use as name, I mean /images cannot work both ways right?
  It goes to public and that is it.

  /db/ allows reading files from the database

  Don't use 'action', 'resource', or 'id' as name. 
  These are reserved to the framework. Also please dont use anything
  starting with underscore (_). If you want to crash the thing it's fine,
  but if you don't then do as stated :P   

  Also names are supposed to be uri encoded, so just stick to the alpha
  -bet and numbers.      

  I am not going to program checks to see if your doing it right.

  Testing would be nice though :) -->
</routes>
  ;

(:
 : Route File for Dylan
 :
 : Copyright (c) 2010 Nuno Job [nunojob.com]. All Rights Reserved.
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

declare function r:match( $node ) { 
  let $k := fn:concat( "get ", $node/@path )
    return if ( $node/d:to )
           then let $to := fn:tokenize( fn:normalize-space( $node/d:to ), "#" )
                  let $file := fn:concat( "/resources/", $to[1], 
                                          ".xqy?_action=", $to[2] )
                  return c:kvpair( $k, $file )
           else if ( $node/d:redirect_to ) 
                then c:kvpair( $k,
                       fn:concat( 
                         "/lib/dylan/invoke.xqy?_action=redirect&amp;url=",
                       xdmp:url-encode(
                         fn:normalize-space( $node/d:redirect_to ) ) ) )
                else c:kvpair( $k, "/lib/dylan/invoke.xqy?_action=default" ) } ;

declare function r:resource($node) {
  let $r     := $node/@name
    for $verb in ( "get", "post", "put", "delete")
      let $k := fn:concat( $verb, " /", $r, "/:id" )
      let $v := fn:concat( "/resources/", $r, ".xqy?_action=", $verb )
    return c:kvpair( $k, $v ),
  let $r         := $node/@name
    let $actions :=  fn:data( $node/d:include/@action )
    for $action in $actions
      let $k := fn:concat("get /", $r,"/:id/", $action)
      let $v := fn:concat( "/resources/", $r, ".xqy?_action=", $action )
    return c:kvpair( $k, $v ) } ;

declare function r:root($node) {
  let $ra   := fn:tokenize ( fn:normalize-space( fn:string($node) ), "#" ) 
    let $file := fn:concat( "/resources/", $ra [1],
                            ".xqy?_action=", $ra [2] )
    return c:kvpair("get /", $file) } ;

declare function r:transform( $node ) {
  typeswitch ( $node ) 
    case element( d:match )    return r:match( $node )
    case element( d:resource ) return r:resource( $node )
    case element( d:root )     return r:root( $node )
    default                    return () } ;

declare function r:generate-regular-expression($node) {
  fn:replace( $node , ":([\w|\-|_]+)", "([\\w|\\-|_]+)" ) } ;

declare function r:extract-labels($node) {
  fn:analyze-string($node, ":([\w|\-|_]+)") //s:match/s:group/fn:string(.) } ;

(: Method to access the configuration file :)
declare function r:routes() { 
  <d:cache> { c:kvpair("get /db/:uri", "get-file.xqy?_action=get") }
    { let $r := document { $routes }
      return for $e in $r/d:routes/* return r:transform($e) }
  </d:cache> } ;
