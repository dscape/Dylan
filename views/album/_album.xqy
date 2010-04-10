xquery version "1.0-ml";
declare variable $album as node() external;

let $title := fn:normalize-space( $album //title )
return 
  <div class="album" xmlns="http://www.w3.org/1999/xhtml"> 
    <h1> { fn:string( $title ) } </h1> 
      [ <a href="/album/{xdmp:url-encode($title)}">more</a> ]
    <div id="artist"> { fn:string( $album //artist ) } </div>
    <div id="songs">
    <h2> Songs </h2>
    { for $song in $album//song
      return <div class="song"> { fn:string( $song ) } </div> }
    </div>
  </div> 