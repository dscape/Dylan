xquery version "1.0-ml";
declare variable $status as node() external;

let $title := fn:normalize-space( $status //title )
return 
  <div class="status" xmlns="http://www.w3.org/1999/xhtml"> 
    <h1> { fn:string( $title ) } </h1> 
      [ <a href="/status/{xdmp:url-encode($title)}">more</a> ]
    <div id="user"> { fn:string( $status //user ) } </div>
  </div> 