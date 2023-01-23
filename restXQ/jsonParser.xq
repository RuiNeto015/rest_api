module namespace jsonParser="http//estg.ipp/parser";

declare function jsonParser:familyMembers($x as element()) as element()*{
  for $e in $x//member
  let $firstName:= $e//name//firstName//text()
  let $lastName:= $e//name//lastName//text()
  let $birthdayDate:= $e//birthdayDate/text()
  let $genre:= $e//genre/text()
  return 
    <map xmlns="http://www.w3.org/2005/xpath-functions">
      <map key="name">
        <string key="firstName">{$firstName}</string>
        <string key="lastName">{$lastName}</string>
      </map>
      <string key="birthdayDate">{$birthdayDate}</string>
      <string key="genre">{$genre}</string>
    </map>
};

declare function jsonParser:updateFiles(){
  if (file:exists("export")) then 
  file:delete("export", boolean('0'))
};

