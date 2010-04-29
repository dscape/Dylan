xquery version "1.0-ml" ;

declare variable $sections as map:map external;

xdmp:set-response-content-type( "application/xhtml+xml" ),
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <title> { map:get( $sections, 'title' ) } </title>
  <link href="/css/screen.css" media="screen" rel="stylesheet" type="text/css"/>
</head>
<body id="home">
  <div id="wrapper">
    <div id="header">
       <h1> { map:get( $sections, 'title' ) } </h1>
    </div>
    <div id="nav">
      { map:get( $sections, 'nav' ) }
    </div>
    <div id="content">
      <div id="subcol">
        { map:get( $sections, 'subcol' ) }
      </div>
      <div id="maincol">
        { map:get( $sections, 'maincol' ) }
      </div>
    </div>
  </div>
  <div id="footer">
    <p> { map:get( $sections, 'footer' ) } </p>
  </div>
</body>
</html>