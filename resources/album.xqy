(:
 : Sample Resource in Dylan - while there are no generators
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
import module 
  namespace d = "http://ns.dscape.org/2010/dylan/core"
  at "/lib/dylan/base.xqy";

import module 
  namespace album = "my-album"
  at "/models/album.xqy";

declare function local:list( $request ) {
  d:render( 'album', 'list', () ) } ; (: good example for method missing :)

declare function local:get( $request ) {
  let $title := d:id()
    let $album := album:find-by-title ( $title )
    return d:render( "album", "get", $album ) } ;

declare function local:post( $request ) {
  d:error( 501, "Not implemented yet", $request ) } ;

declare function local:put( $request ) {
  d:error( 501, "Not implemented yet", $request ) } ;

declare function local:delete( $request ) {
  d:error( 501, "Not implemented yet", $request ) } ;

    let $_ := xdmp:log("-------------------------------")
    let $_ := xdmp:log( d:request() )
    let $_ := xdmp:log("-------------------------------")  
let $action  := ( d:function(), d:action() ) [ . != "" ] [1]
  return try { xdmp:apply( xdmp:function( xs:QName(
    fn:concat( "local:", $action ) ) ), () ) } catch ( $e ) {
      d:error(501, fn:string( $e//*:message ), $e ) }