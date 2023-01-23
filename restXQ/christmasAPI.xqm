module namespace page = 'http://basex.org/examples/web-page';
import module namespace validateXML= "http//estg.ipp/validateXML" at "validateXML.xq";
import module namespace jsonParser= "http//estg.ipp/parser" at "jsonParser.xq";
import module namespace validate= "http://basex.org/modules/validate";

declare
%updating
%rest:path("/add")
%rest:POST("{$body}")
%rest:consumes("application/xml", "text/xml")
 function page:add($body as document-node()){  
  let $y:= validate:xsd($body, 'C:\Users\Simão\Desktop\ChristmasAPI\xsd\familyTypes.xsd')
  let $x:= validateXML:checksIfNumberOfElementsMatches($body)
  let $z:= validateXML:checkDatePreferences($body)
  let $schedule:= 
  document {
    element schedule{
          element id{concat("SCHEDULE_ID_", count(db:open("agenda")//schedule) + 1)},
          element status{"Active"},
          element numberOfElements{$body/*[name()='family']/*[name()='numberOfElements']/text()},
          element scheduleDate{$z//text()},
          element country{$body/*[name()='family']/*[name()='country']/text()},
          element city{$body/*[name()='family']/*[name()='city']/text()},
          element contacts{
            element phoneNumber{$body/*[name()='family']/*[name()='contacts']/*[name()='phoneNumber']/text()},
            element email{$body/*[name()='family']/*[name()='contacts']/*[name()='email']/text()}
          },
          element members{
            for $x in $body/*[name()='family']/*[name()='members']/*[name()='member']
            return element member{
              element name {
                element firstName{$x/*[name()='name']/*[name()='firstName']/text()},
                element lastName{$x/*[name()='name']/*[name()='lastName']/text()}
              },
              element birthdayDate {$x/*[name()='birthdayDate']/text()},
              element genre{$x/*[name()='genre']/text()}
            }
          }
    }
  }
  return db:add("agenda", $schedule, concat("SCHEDULE_ID_", concat(count(db:open("agenda")//schedule) + 1, ".xml")))
};
 
declare 
%rest:path("/getSchedules")
%rest:GET
 function page:getSchedules() as element()*{
   for $x in db:open("agenda")//schedule
   return $x
}; 
 
declare 
%rest:path("/getAvailableSlotsInTimeInterval")
%rest:GET
%rest:query-param("startDate", "{$startDate}")
%rest:query-param("finishDate", "{$finishDate}")
 function page:get($startDate as xs:date, $finishDate as xs:date) as element()*{
   if($startDate >= $finishDate) 
   then
   fn:error(xs:QName("ERROR"), "starDate is higher or equal then finishDate")
   else
   for $x in db:open("agenda")//schedule[status = "Active"]
   where $x//scheduleDate >= $startDate and $x//scheduleDate <= $finishDate
   let $scheduleDate:= $x//scheduleDate
   group by $scheduleDate
   return 
   <result>
     <scheduleDate>{$scheduleDate}</scheduleDate>
     <count>{50 - count($x)}</count>
   </result>
};
 
declare
%updating
%rest:path("/cancelSchedule")
%rest:DELETE
%rest:query-param("id","{$id}")
function page:delete($id as xs:string){
  if(count(db:open("agenda")//schedule[id=$id and status = "Active"]) >  0)
  then
  replace value of node db:open("agenda")//schedule[id=$id]//status with "Canceled"
  else 
  fn:error(xs:QName("ERROR"), "id is not valid")
};

declare
%rest:path("/export")
%rest:GET
function page:export() as item()*{  
  let $deleteIfNecessary:= jsonParser:updateFiles()
  let $dirExport:= file:create-dir("export")

  for $x at $i in db:open("agenda")//schedule
  let $status:= $x//status/text()
  let $numberOfElements:= $x//numberOfElements/text()
  let $scheduleDate:= $x//scheduleDate/text()
  let $country:= $x//country/text()
  let $city:= $x//city/text()
  let $phoneNumber:= $x//contacts//phoneNumber//text()
  let $email:= $x//contacts//email//text()
  let $members:= jsonParser:familyMembers($x//members)
  return file:write(concat("export/",concat($x//id/text(), ".json")), fn:xml-to-json(
    <map xmlns="http://www.w3.org/2005/xpath-functions">
    <string key="status">{$status}</string>
    <number key="numberOfElements">{$numberOfElements}</number>
    <string key="scheduleDate">{$scheduleDate}</string>
    <map key="location">
      <string key="country">{$country}</string>
      <string key="city">{$city}</string>
    </map>
    <map key="contacts">
       <string key="phoneNumber">{$phoneNumber}</string>
       <string key="email">{$email}</string>
    </map>
    <array key="members">{$members}</array>
    </map>) )
};
 