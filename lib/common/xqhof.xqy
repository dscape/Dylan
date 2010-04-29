xquery version "1.0-ml";

module namespace xqhof = "http://ns.dscape.org/2010/xqhof";

(:
 : XQuery High Order Functions Library for Mark Logic Server
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
declare function xqhof:id($x)    { $x } ;
declare function xqhof:fst( $l ) { $l[1] } ;
declare function xqhof:snd( $l ) { $l[2] } ;
declare function xqhof:head($l) { $l[1] } ;
declare function xqhof:tail($l) { fn:subsequence($l, 2) } ;
declare function xqhof:last($l) { $l[fn:last()] } ;

declare function xqhof:take($n, $l) {
  fn:subsequence($l, 1, $n) } ;

declare function xqhof:drop($n, $l) {
  fn:subsequence($l, $n+1) } ;

declare function xqhof:fold($f, $z, $l) { 
  if(fn:empty($l)) then $z
  else
    xqhof:fold($f,
      xdmp:apply($f, $z, xqhof:head($l)),
      xqhof:tail($l)) } ;

declare function xqhof:reduce($f, $z, $l)     { xqhof:fold($f, $z, $l) } ;
declare function xqhof:inject($f, $z, $l)     { xqhof:fold($f, $z, $l) } ;
declare function xqhof:accumulate($f, $z, $l) { xqhof:fold($f, $z, $l) } ;
declare function xqhof:compress($f, $z, $l)   { xqhof:fold($f, $z, $l) } ;

declare function xqhof:map($f, $l) {
  for $e in $l return xdmp:apply($f, $e) } ;

declare function xqhof:collect($f, $l)  { xqhof:map($f, $l) } ;
declare function xqhof:tranform($f, $l) { xqhof:map($f, $l) } ;

declare function xqhof:filter($f, $l) {
  $l[xdmp:apply($f, .)] } ;

declare function xqhof:select($f, $l)  { xqhof:filter($f, $l) } ;
declare function xqhof:grep($f, $l)    { xqhof:filter($f, $l) } ;

declare function xqhof:reject($f, $l) {
  $l[fn:not(xdmp:apply($f, .))] } ;

declare function xqhof:every($f, $l) { 
  every $e in $l satisfies xdmp:apply($f, $e) } ;

declare function xqhof:all($f, $l) { xqhof:every($f, $l) } ;

declare function xqhof:some($f, $l) { 
  some $e in $l satisfies xdmp:apply($f, $e) } ;

declare function xqhof:any($f, $l) { xqhof:some($f, $l) } ;

declare function xqhof:head-two( $l )   { fn:subsequence( $l, 1, 2 ) } ;
declare function xqhof:tail-two( $l )   { fn:subsequence( $l, 3 )    } ;
declare function xqhof:fold2($f, $z, $l) { 
  if( fn:empty( $l ) ) then $z else
    xqhof:fold2( $f, 
                xdmp:apply( $f, $z, xqhof:head-two( $l ) ),
                xqhof:tail-two( $l ) ) } ;