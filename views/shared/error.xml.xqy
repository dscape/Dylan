xquery version "1.0-ml";

declare variable $params as node() external;

<error http-code="{ $params//*:http-code }">
  <description> { $params//*:description } </description>
  <timestamp> { $params//*:timestamp } </timestamp>
  <stack> { $params//*:stack-trace } </stack>
</error>
