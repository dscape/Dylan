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
declare namespace s = "http://www.w3.org/2009/xpath-functions/analyze-string" ;

import module 
  namespace r = "http://ns.dscape.org/2010/dylan/cfg/routes" 
  at "/config/routes.xqy" ;

import module 
  namespace d = "http://ns.dscape.org/2010/dylan/core"
  at "/lib/dylan/base.xqy";

let $route := d:route()
  let $req := fn:string-join( ( d:verb(), d:route()), " " )
  return 
    if ( fn:matches($req,  "get /(images|css|js)/.*") )
    then fn:concat("/public", $route)
    else
      let $cache := r:routes()
        let $selected := $cache //d:kvp [ fn:matches( $req, fn:concat( 
          r:generate-regular-expression(@key), "$" ) ) ] [1]
        return 
          if ($selected)
          then let $route     := $selected/@key
                 let $file    := $selected/@value
                 let $regexp  := r:generate-regular-expression( $route )
                 let $labels  := r:extract-labels( $route )
                 let $matches := fn:analyze-string( $req, $regexp ) 
                   //s:match/s:group/fn:string(.)
                 let $params := 
                   if ($matches) 
                   then fn:concat( "&amp;",
                     fn:string-join( for $match at $p in $matches
                       return fn:concat("_", $labels[$p], "=",
                       xdmp:url-encode($match)) , "&amp;") )
                   else ""
                 return fn:concat($file, $params)
             else "404.xqy"