xquery version "1.0-ml";
module namespace gen = "http://ns.dscape.org/2010/generate-tree";

import module namespace xqh = "http://ns.dscape.org/2010/xqhof"
  at "xqhof.xqy" ;
import module namespace mem = "http://xqdev.com/in-mem-update"
  at "/MarkLogic/appservices/utils/in-mem-update.xqy" ;

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

(: 
 : Generate an XML tree based on a sequence of XPaths 
 : Original commented work at http://gist.github.com/364356
 :)
declare variable $redo as xs:string* := (); (: hack, should be in fold :)

declare function gen:process-fields( $xpaths, $values ) {
  let $tree := gen:generate-tree( $xpaths )
    return gen:populate-tree( $tree, $xpaths, $values ) } ;

declare function gen:generate-tree( $xpaths ) {
  let $f := xdmp:function( xs:QName( 'gen:generate-tree-step' ) )
    return xqh:fold( $f, (), $xpaths ) } ;

declare function gen:populate-tree( $tree, $xpaths, $values ) {
  let $pairs := for $xpath at $i in $xpaths return ( $xpath, $values[$i] )
    let $f := xdmp:function( xs:QName( 'gen:populate-tree-step' ) )
    return document { xqh:fold2( $f, $tree, $pairs ) } } ;

declare function gen:generate-tree-step( $current-tree, $xpath ) {
let $_ := xdmp:set( $redo, () )
  let $f := xdmp:function( xs:QName( 'gen:create-nodes' ) )
    return xqh:fold( $f, $current-tree,
      xqh:tail( fn:tokenize( $xpath, "/" ) ) )  } ;

declare function gen:populate-tree-step ( $current-tree, $pair ) {
  let $xpath           := xqh:fst( $pair )
    let $value         := xqh:snd( $pair )
    let $relative-path := fn:replace($xpath, "^/\w+(/.*)", "$1")
    let $selected      :=
      xdmp:unpath( fn:concat( "$current-tree", $relative-path ) )
    return gen:replace-value( $selected, $value ) } ;

declare function gen:replace-value( $node, $value ) {
  if( xdmp:node-kind($node) = "attribute" )
  then mem:node-replace( $node, attribute {fn:node-name( $node )} {$value} )
  else mem:node-replace( $node, element {fn:node-name( $node )} {$value} ) } ;

declare function gen:insert-child( $parent, $child ) {
  if( xdmp:node-kind($child) = "attribute" )
  then mem:node-insert-before( ($parent/*)[1] , $child )
  else mem:node-insert-child( $parent , $child ) } ;

declare function gen:create-nodes( $current-node, $xpath-step ) {
  let $current-node-name := $current-node /fn:local-name(.)
    let $new-node        := 
      if ( fn:starts-with( $xpath-step, "@") )
      then attribute { fn:substring( $xpath-step, 2 ) } {}
      else element   { $xpath-step } {}
    let $new-node-name   := $new-node /fn:local-name(.)
    let $steps           := fn:string-join( xqh:tail( $redo ), "/" )
    let $child           := if( $steps )
      then xdmp:unpath( fn:concat( "$current-node/", $steps ) )
      else xdmp:unpath( fn:concat( "$current-node/", $xpath-step ) )
let $_ := xdmp:set( $redo, ( $redo, $xpath-step ) )
    return if( fn:empty( $current-node )  ) 
      then $new-node
      else if( $current-node-name = $new-node-name )
        then $current-node
        else
          if ( $steps ) 
          then 
            if ( $child ) 
            then gen:insert-child( $child , $new-node ) 
            else gen:insert-child( $current-node , $new-node )
          else 
            if( $child ) 
            then $child
            else gen:insert-child( $current-node , $new-node ) } ;
