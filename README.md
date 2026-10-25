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
Keys for farming (in development):
	left-click mouse: farm land 
		if pressed with the pointer on left side: farm left
		if pressed with the pointer on right side: farm right
	extraction tool - ...next

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

Github: https://github.com/eric-dotcom-rgb/
Terra: noobatcoding
Slack: noobatcoding

# !!warning!!

This game is still in development. It is NOT the finished product.
