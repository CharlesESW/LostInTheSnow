# Durhack24

## How to compile/run

To play this game you will need to have Haskell installed on your machine.
To compule and run the game please type `ghci GameLoop.hs -e main` in your cloned repo folder.

## Goal

Navigate yourself through the mountains, avoiding pitfalls to survive and escape to civilisation. Along the way piece together the story on how you came to be Lost in the Snow.

## Player instructions

This game operates entirely in lapslock, using uppercase will not work.

### Commands

- `go [north/east/south/west]`
- `show [inventory/scene]`
- `take [item]`
- `use [item]`
- `help`

## ToDos

- Scene Flag implementation to interact more with the environment
- Add more scenes to extend the map
- Interactive pieces of the scene, such as cupboards
- Moving within scenes
