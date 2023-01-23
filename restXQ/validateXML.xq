module namespace validateXML = 'http//estg.ipp/validateXML';

declare function validateXML:checksIfNumberOfElementsMatches($body as document-node()) as empty-sequence(){
  let $x:= $body
  return if (count($x/*[name()='family']/*[name()='members']/*[name()='member']) != $x/*[name()='family']/*[name()='numberOfElements'])
  then 
  fn:error(xs:QName("ERROR"), "Number of elements doesn't match the number of elements")
};

declare function validateXML:countFamiliesInThisDate($dateP as element()) as element()*{
 for $x in db:open("agenda")//schedule[scheduleDate = $dateP and status = "Active"]
 return $x
};

declare function validateXML:checkDatePreferences($body as document-node()) as element(){ 
  let $result:= (for $x in $body/*[name()='family']/*[name()='datePreferences']/*[name()='datePreference']
  where($x >= xs:date("2021-09-15") and $x <= xs:date("2021-12-24"))
  where count(validateXML:countFamiliesInThisDate($x)) + 1 <= 50
  return $x)
  return if ($result[fn:position() = 1]/text() != "")
  then 
  $result[fn:position() = 1]
  else 
  fn:error(xs:QName("ERROR"), "Non of DatePreferences are available")
};