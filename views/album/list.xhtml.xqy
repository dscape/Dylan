xquery version "1.0-ml";

'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
                       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title> Listing Albums </title>
  </head>
  <body>
    <div id="search"> { ' ' } </div> 
    <div id="facets"> { ' ' } </div>
    <div id="main"> { for $album in fn:doc() [1 to 10]
      order by $album /artist
      return xdmp:invoke( '_album.xqy', ( fn:QName( "", "album" ) , $album), () ) }
    </div>
  </body>
</html>
