(:
 : Routing logic for Dylan
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
declare 
  namespace s = "http://www.w3.org/2009/xpath-functions/analyze-string";

import module 
  namespace r = "http://ns.dscape.org/2010/dylan/cfg/routes" 
  at "../../config/routes.xqy" ;

import module 
  namespace d = "http://ns.dscape.org/2010/dylan/core"
  at "../dylan/base.xqy";

import module 
  namespace c = "http://ns.dscape.org/2010/dylan/cache"
  at "../common/cache.xqy";

(: idea is to put in the cache to avoid overhead of doing this 
   for every request - refreshed when application is refreshed
   or by using script/routes :)

declare function r:match( $node ) { 
  let $k := fn:concat( "get ", $node/@path )
    return if ( $node/d:to )
           then let $to := fn:tokenize( fn:normalize-space( $node/d:to ), "#" )
                  let $file := fn:concat( "/resources/", $to[1], 
                                          ".xqy?_action=", $to[2] )
                  return c:kvpair( $k, $file )
           else if ( $node/d:redirect_to ) 
                then c:kvpair( $k,
                       fn:concat( "/lib/dylan/redirect.xqy?url=",
                       xdmp:url-encode(
                         fn:normalize-space( $node/d:redirect_to ) ) ) )
                else c:kvpair( $k, "/lib/dylan/invoke.xqy" ) } ;

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

(: will be in memory in a next iteration when caches are implemented :)
let $cache :=
  <d:cache> {
    let $r := r:routes() 
      return for $e in $r/d:routes/* return r:transform($e) }
  </d:cache>
  let $_ := xdmp:log($cache)
let $req := fn:string-join( ( d:verb(), d:route()), " " )
let $selected := $cache //d:kvp [ fn:matches( $req, fn:concat( 
  r:generate-regular-expression(@key), "$" ) ) ] [1]
return   if ($selected)
         then let $route    := $selected/@key
                let $file   := $selected/@value
                let $regexp := r:generate-regular-expression( $route )
                let $labels := r:extract-labels($route)
                let $_ := xdmp:log ( $regexp )
                let $_ := xdmp:log( fn:string-join($labels, ", ") )
                let $_ := xdmp:log ( $route )
                return "not404.xqy"
         else "404.xqy"

(: remember to add public as accessible from outside :)
(: let $routes   := r:routes()
  let $route    := d:route()
  let $selected := $routes //d:route [
      fn:matches($route, d:pattern) 
      and d:verb() = d:verb ] [1]
  return if ($selected)
         then
           let $pattern  := $selected//d:pattern
           let $resource := $selected/d:resource/@name
           let $redirect := fn:concat($resource, ".xqy")
           let $params   := fn:concat( "?", 
                              fn:string-join( for $p in $selected//d:match
                                return 
                                  let $resource := xdmp:url-encode(
                                    fn:analyze-string($route,$pattern)
                                      //s:group[@nr eq $p/@nr] )
                                  return if ($resource)
                                         then fn:concat( fn:string($p), "=",
                                   $resource ) else () , "&amp;" ) )
           return fn:concat($redirect, $params)
         else
           "404.xqy" :)