xquery version "1.0-ml";

declare variable $params as node() external;

 (: Monkey patched for development. Not final yet :)
let $stack := fn:string-join(for $e in $params//*:stack-trace//* 
                return fn:concat(fn:string(fn:node-name($e)), ": '", fn:string($e), "'"), "------------------")
  return fn:concat("{
    error: {
      status:", $params//*:http-code , ",
      description: '", $params//*:description ,"',
      timestamp: '", $params//*:timestamp ,"'",
      if ($stack) then fn:concat(", stack: {", $stack ,"}") else "",
      "  } }")
