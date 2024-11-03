module Scenes where
import Gamestate.GameState
import Control.Monad.State


{-
NEED

Scene Description
Inventory for the room to compare against user input
List of Scenes

-}
type Description = String
type Inventory = [String]


--EXTRA Scene flags will only affect the scene whilst in it, will reset upon departure
type Scene = (Description, Inventory)

type AllScenes = [Scene]

getMap :: [(String, [String])]
getMap = [("you open your eyes to a cold white landscape, lying down with a hat and gloves set [set] beside you. all around there are snowy mountains, and in your small clearing is a mysteriously desolate campsite. looking around, you spot an envelope addressed to 'My Son'. strangely you can only pick up one thing.", ["letter", "set"]), 
    ("the climb up the least harrowing slope is still quite treacherous, but you make it over the hill. winds are picking up and all you can see is white. all white except from a slight glimmer on the ground - it's a coin!",["coin"]), 
    ("winding carefully through a rocky path gets you to an alcove. it looks like you're not the first person here, perhaps there will be some clues on why you're here. there is a single ski. there is a fraying rope.",["ski", "rope"]), 
    ("the air up here is pretty thin, luckily you seem to be in pretty good shape for the climb. the ground underfoot isn't visible, leading you to trip on a strange mound. there is a coat.",["coat"]), 
    ("you hike into an area that is covered in slippery ice, making it difficult to traverse. the clearing is exposing you to the cold winds, you might need to find some gear soon.",[]), 
    ("looking northwards you see the area that you woke up in. the snow really hides how far you travel. echoes are coming from the dip to the east, is there something down there?",[]), 
    ("NULL",[]), 
    ("the view from up here is incredible, but looking west you realise you've been travelling in an upwards spiral. the south looks rockier, i'd be careful but it could be hiding something useful. There is a ring on the floor nearby.",["ring"]), 
    ("you feel a little warmer as you approach a smouldering fire, it doesn't seem like it will be much use but there's some matches beside it",["matches"]), 
    ("a harsh wind blows and you feel yourself shivering, hopefully it doesn't get any colder than this",[]), 
    ("jagged rocks surround you, threatening to skewer you with any wrong step, you had better watch your step around here",["jerky"]), 
    ("you finally touch grass, and know you have almost escaped this nightmare, you just hope you don't take a wrong step now. it appears this path has been very well trodden in recent days",[]), 
    ("NULL",[]), 
    ("you wade through thick snow to get to a group of hares jumping around, there joy reminds you of something you can't quite remember",[]), 
    ("you arrive upon a snowy copse of trees, there doesn't seem to be much around but you think there might be faint carvings in the bark",[]), 
    ("greenery is peeking through the snow, the sun is actually giving heat; these must be signs that you're almost there. there is a torch. there is a flare. there is a camera.",["torch", "flare", "camera"]), 
    ("leaving the mountain must be such a relief, congratulations on your survival thusfar. unfortunately it is still unknown how you even ended up here; and just what did happen to your friend...",[])]