xquery version "1.0-ml" ;
module  namespace r = "http://ns.dscape.org/2010/dylan/cfg/routes" ;

declare variable $routes :=
<routes xmlns="http://ns.dscape.org/2010/dylan/core">
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
  <resource name="user"/>
  <resource name="album">
    <include action="songs"/>
  </resource>
  <match path="/feed">
    <redirect_to> http://feedburner.com/sample_feed </redirect_to>
  </match>
  <match path="/logout"> <to> sessions#delete </to> </match>
  <match path="/activate/:key"> <to> user#activate </to> </match>
  <root> album#list </root> 
  <match path="/:resource/:action/:id"/>
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

(: Method to access the configuration file :)
declare function r:routes() { document { $routes } } ;
