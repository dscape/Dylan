(:
 : Invoker for Dylan 
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
xquery version "1.0-ml";
import module 
  namespace d = "http://ns.dscape.org/2010/dylan/core"
  at "/lib/dylan/base.xqy";
import module namespace s = "http://ns.dscape.org/2010/dylan/string" 
    at "/lib/common/string.xqy" ;

let $action := d:action()
  return 
    if ( $action = 'default' )
    then xdmp:invoke( s:q( "/resources/$1.xqy", ( d:resource() ) ), () ) 
    else "redirecting --- not really.."
