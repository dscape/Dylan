xquery version "1.0-ml";

declare variable $params as node() external;

'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
                       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title> Listing Status </title>
  </head>
  <body>
    <div id="search"> { ' ' } </div> 
    <div id="facets"> { ' ' } </div>
    <div id="main"> { for $status in fn:doc() [1 to 10]
      return xdmp:invoke( '_status.xqy', ( fn:QName( "", "status" ) , $status), () ) }
    </div>
  </body>
</html>
