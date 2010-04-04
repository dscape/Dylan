(:
 : Accessing Documents with RDBC
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
import module namespace rdbc = "http://ns.dscape.org/2010/rdbc/core"
  at "lib/base.xqy";

(: Warning - This is not ready for production if your user is not trusted.
 : e.g. on a public website you always need to sanitize every thing the user
 : provides you, however that layer does not exist here
 :
 : This is just a demo of a simple stripped down, generic, restful architecture in 
 : marklogic. If you like it don't forget security. This is not a web framework.
 :)

declare function local:get($request) {
  try { 
    let $doc     := $request//rdbc:body/rdbc:doc
      let $db      := $request//rdbc:body/rdbc:db
      let $options := if ($db) then <options xmlns="xdmp:eval">
  		    <database>{xdmp:database($db)}</database>
  		  </options> else ()
      return rdbc:render('doc', 'get', xdmp:eval( 
               rdbc:q("fn:doc('$1')", ($doc)), (), $options )) 
  } catch ($e) {
    rdbc:error(501, fn:string($e//*:message), $e) } } ;

declare function local:delete($request) {
  try {
    let $doc     := $request//rdbc:body/rdbc:doc
      let $db      := $request//rdbc:body/rdbc:db
      let $options := if ($db) then <options xmlns="xdmp:eval">
  		    <database>{xdmp:database($db)}</database>
  		  </options> else ()
      let $_       := xdmp:eval( fn:concat("xdmp:document-delete('", $doc ,"')"), (), $options )
      return rdbc:render('doc', 'delete', ())
  } catch ($e) {
    rdbc:error(501, fn:string($e//*:message), $e)
  } } ;

declare function local:put($request) {
  "Not Implemented yet"
} ;

declare function local:post($request) {
  "Not Implemented yet"
} ;

let $request := rdbc:request()
let $verb    := $request//rdbc:verb[1]
return xdmp:apply( xdmp:function(xs:QName(
  fn:concat("local:", $verb))), $request )