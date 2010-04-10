xquery version "1.0-ml";

<albums> { for $album in (/album) [1 to 10]
  order by $album /artist
  return $album }
</albums>