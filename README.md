# Yard of Despair

A farming game in which you are a young teen grounded by his parents,
in which you get to know other farmers and expand your farmland!

# Yard of Despair-Why?

A world in which you get to farm various crops and expand your land! 
On the map you can meet other farmers that have lots of adventures to 
talk about. Some of them are very old, some old, others with a lot of 
years of experience...BUT there's also young people! Hurray! 
In this world you are seen as a yellow lemon with beautiful dark brown
hair and a pair of ravishing orange eyes...if you're asking 'Why 
orange?', weel, it's the developers favourite color!^_^ The player has
also got that modern style of clothes, which...is strange for a farmer!
Well said, and that brings us to the title: Yard of Despair.
Why 'Despair'? There's nature, growing farmland, communication with other
people...well, for the player, it's the summer period after school that 
he could well spend travelling to other countries and have fun in general,
but his parents grounded him for bringing home low grades all year: it's
a punishment for him to go farming!

# Mechanics

Keys for movement:
	W - going up
	S - going down
	A - going left
	D - giong right
Key for farming:
	F: farm land 
		if pressed with the pointer on left side: farm left
		if pressed with the pointer on right side: farm right
		max a min distance from player to farm: 16px or 1 block
		you need to hover the tile you want to farm for maximum precision
Key for main menu:
	ESC
	In the main menu you can:
	-Resume the game that you started before by pressing 'RESUME'
	 (if you never played before, the game automatically leaves only the new game 
	 button because you don't have a save file in which the player position and 
	 the farm tiles are saved by ID)
	-Start a new game by pressing 'NEW GAME'
	 !!! CAUTION: This button deletes the save file, so progress will be lost !!!
	-Exit the game by pressing 'EXIT' and either confirm the action or go back to menu
	 !!! CAUTION: You MUST close the game by pressing on the button. If you do the classic
	 Alt+F4 to close the game, no progress will be logged on user !!!
Key for planting seed:
	left-click mouse: plant seed
		if pressed with the pointer on left side: plant left
		if pressed with the pointer on right side: plant right
		max a min distance from player to farm: 16px or 1 block
		you need to hover the tile you want to farm for maximum precision
Keys for changing crop on the hotbar:
	Press Keys to access the descripted crops
	1 -> carrot
	2 -> hot chili pepper
	3 -> onion
	4 -> potatoe
	5 -> pumpkin

# Characteristics - Code

Week 1:
For player:
I've done the code for the speed of the player and the various animations.
I made functions and variables about the state of the player so I could control 
what animation to play, when and for how much time. I made the animation tree log
on whenever the game starts so it would display all the animations. The player idles 
when nothing is pressed, plays the walk animation whenever the d, w or s keys
are pressed adn it rotates the h whenever the a key is pressed (from right to
left). Depending on where the left click of the mouse is pressed, it plays the
farm anbimation on the right. If the mouse pointer is on the left, it reverses the h 
of the frames so it farms on the left. You can farm both when you're walking or when
you're idling. Whenever the animation of farm is played, the walking and the idling 
are stopped so the farm animation doesn't bug.
For world:
I added some grass blocks and some border blocks to start with. I made the border 
blocks so they could actually stop the player from exiting the map, adding the collision 
square where there is the grey part (the wall of the map). 
For farmer 1:
I made him start idling whenever the game stats and layed the tree so next week I can 
start coding the talking part right away. Maybe I'll add some more animations like
for anger or something else so like when you try to give/sell him a crop that's not 
accepted he'll do that animation, or something like that.

Week 2:
Player:
Added the logic for the function farm which tells everything about mouse positioning and
flipping of the animation so it can determine which block to farm. It also determines
the distance from the player of the block that can be modified. The distance is set to
16 pixels, so 1 block in my game. You can farm up, down, left or right depending on which 
block you press with the mouse pointer.
Menu:
I made a menu that can be accessed by pressing ESC and got 3 options: resume, new game and 
exit. The resume option opens the saved file 'save_file.cfg' and adds it to the tree so the
progress made by the user can be showed. The file is saved into 
C:>user>AppData>Roaming>Godot>app-userdata>Yard of Despair if you download the files, or
C:>user>AppData>Roaming>Yard of Despair if you download the executable. The new game option
deletes the file of progress, if you have one, and starts a new game. When you will decide to
use the exit option, it will save automatically the file once you confirm the exit by pressing
'...Yes'. You can also press 'No :)' if you decide to play some more (in current state I doubt
you want to XD).

Week 3:
World:
Added a farming system in which you can plant your seeds and pick up the crops after. The 
system saves the stages of the growth of the seed and the position of the planted seeds. By 
"stages" I mean that when the seed is planted, the seed transforms into a light green plant(stage 1),
then into a green plant(stage 2), and finally the crop grows and you can pick it up. The sysatem also
saves the amount of seeds in your inventory, how many crops do you have and the coins you got(for
now I only added the slot and the tag, but it doesn't work until I put a shop in the game). The 
seeds and crops are each saved by the type of vegetable you chose to plant. So, don't worry, your
plants won't get lost or mixed up! Also, each type of crop got its own growing times, so, be patient!
HUD:
Added an inventory that indicates the current slot, the amount of crops and seeds you have and coins.
The slot can be changed by pressing from 1 to 5, as there are exatcly 5 kinds of crops avaiable to plant.
The crop counter counts how many fresh vegetables you picked up from the ground of that kind. The seed 
counter counts how many seed you have for that type of vegetable. The two counters may vary if you press for
example 1-Carrots or 5-Pumpkins. For example, if you plant 3 seed of carrot, the seed counter on the carrot
slot will say: 2, because you used up 3 of the 5 seed you initially get for every vegetable. But, if you press
the number 5-Pumpkin, it will display that you have still 5 seed, because you haven't planted any!
Player:
I modified the farm button because I will try to use the main action button as the left click of the mouse now.
To farm, now you need to hover with the pointer the dirt tile you want to farm and simply press F. Be aware tho,
you cant farm tiles below your feet or more distant than 1 block! It's a physics rule: you can't just farm the
ground by looking at it irl! Also, now you can plant by using the main action button, the left click of the mouse.
Same physics of the farming action, different style: instead of the farm animation we got the "seed" animation.
Tiles:
Resolved some tile problems with the sky, as Godot wanted to make a 32x32 tile place like a 16x16, so the center
was anchored and then it would just create an overborder onto the next tile. So I changed the origin tile and moved
it by 8 px by each axis so at least it would place corretcly in the map. Then I placed all the tiles by hand because
if I used the square option to just select the area and put them all, it would cover a 16x16 tile and overborder onto
the near 3 tiles, and then that 3 tiles would be filled with another tile that would overborder onto the next ones and
so on, ann it looked all bugged and horrible, so I placed them by hand all around the map.
Files:
Added a cropdata main file that store all the basic things for a crop like seed image, crop image, growing time, ids of
the tiles of sprouts and the id of the tile with the crop. Then copied all of it for every crop in a .tres file with the 
crop name for each one.

# Characteristics - Animations

Week 1:
For various functions and keys rearrangements, I made a pixel art 
spritesheet all by myself, which includes the idling, the walk, the 
extraction tool(in development) and the farming action. I also made
an initial spritesheet for a farmer, but I preferred to concentrate on the
player this week, as it's the most important thing to do in the game.
Update:
I also added the farmer and its animations of idling and talking and
made the initial tree with the idling.Next week I'm giong to adress also the
talking when it will talk its story/missions(I'll see what to do).

Week 2:
Updated the farm animation. Made animations for frogs and all the animated tiles of water.

Week 3:
Made the seed animation for player and the growing of the seed, if it counts as animation(but isnt).

# Characteristics - Pixel Art

All the pixel art that you see in the game is made by myself either on 
Piskel or - in major part of the project - made in Asesprite. All was recorded
with Lapse, because Asesprite for some reason wouldn't allow me to add the 
hackatime extension. All reviewers can access my recordings - not the normal
people tho: I didn't want to show my desktop in public - sorry! (it's too 
organized, I risk to get copied ;-^ ).

Week 1:
I made the grass blocks, soil blocks and crop land blocks, which include:
	-grass block w flowers
	-grass block
	-grass block w dirt

	-dirt block
	-dirt block w roots

	-soil
	-soil w light green plants
	-soil w green plants
	-soil w potatoes
	-soil w carrots
	-soil w onion
	-soil w pumpkin
	-soil w hot chili peppers
I made the player spritesheet, which include:
	In order:
	-idle (5 frames)
	-walk (6 frames)
	-extraction of farming tool (5 frames)
	-farming (8 frames)
I made the borders for the map, which incude:
	-border block right
	-border block left
	-border block up
	-border block down
	-corner border left up block
	-corner border right up block
	-corner border left down block
	-corner border right down block
I made the desktop icon for the game(icon game.png)

Week 2:
Map:
NEW MAP DROPPED! In this map you get YOUR OWN FARMING SOIL! The map now is more like an
island shape because it is an isolated place(kid is grounded, couldn't be any worse), and it got
some nice lakes and borders. Corner borders tiles got an update last week so I made hitboxer for
the new tiles.
Sprites:
I made some spritesheets for some frogs I added.
	-frog breath spritesheet.png
	-frog idle spritesheet.png
Pixel art:
I made the tiles for water with various options to choose, some trees, a house, and some grass tiles
for upcoming elevated ground.
	-player house.png
	-apple tree.png
	-flower tree.png
	-tree.png
	-grass elevated w flowers.png
	-grass elevated w flowers and rocks.png
	-grass corner right down.png
	-grass corner left down.png
	-grass corner center down.png
I made animated tiles for water and sky and some more art
	-water corner left up animated.png
	-water corner left down animated.png
	-water corner right up animated.png
	-water corner right down animated.png
	-water center animated.png
	-tree golden.png
	-sky spritesheet.png
	-sky road var1 spritesheet.png
	-sky road var2 spritesheet.png
	-sky gate.png

Week 3:
Done all the positioning of the sky tiles and the gates and the sky road. I also made the base of the
inventory and updated the player spritesheet and done some new hotbar images for the crops and seeds:
	-player sheet.png (updated)
	-inventory.png
	-carrot inventory.png
	-carrot seed inventory.png
	-onion inventory.png
	-onion seed inventory.png
	-pumpkin inventory.png
	-pumpkin seed inventory.png
	-hot chili peppers inventory.png
	-hot chili peppers seed inventory.png
	-potato inventory.png
	-potato seed inventory.png

# How to run - Requisites

- Download the Godot Engine v4.x so it can run the script and run the game 
	(only required for: Option 1 - How to run)
- Windows tested

# How to run

Option 1: With game engine
1. Download all the updated repositories in a folder
2. Open Godot and import the project folder
3. Open the project and run it by clicking f5 on the keyboard
4. Enjoy the game!

Option 2: Download the .exe
1. Go to releases on Github
2. Download the Yard of Despair.exe file
3. Run it on your pc!

!- it is a game in progress, so don't expect it to be perfect, neither complete 
of the list of things I cited in the description. Follow along the Github project 
to know when it's done!

# Credits

Developed by: Eric Gervasi

# Links

Github: https://github.com/eric-dotcom-rgb/Yard-of-Despair/
Gitlab: https://gitlab.com/eric-gg/yard-of-despair
Terra: noobatcoding
Slack: noobatcoding

# Code

I used Godot engine to create the game and used languages like GDScript, Godot 
Resource and Markdown for writing the readme on VSCode. I also used Lapse to record
my drawings.

# !!warning!!

This game is still in development. It is NOT the finished product.
