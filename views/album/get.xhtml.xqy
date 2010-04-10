xquery version "1.0-ml";
declare variable $album as node() external;

'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
                       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title> Album  { $album //title } by { $album //artist }  </title>
  </head>
  <body>
    <div id="search"> { ' ' } </div> 
    <div id="facets"> { ' ' } </div>
    <div id="main"> 
      { xdmp:invoke( '_album.xqy', ( xs:QName( "album" ) , $album)  }
    </div>
  </body>
</html>