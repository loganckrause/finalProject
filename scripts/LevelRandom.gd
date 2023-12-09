extends Node

var levellist = [1,2,3,5,6,7,9,10]
var levelChoice = levellist.pick_random()
var levelCount = 0

func randomLevel():
	if levelCount != 4 or levelCount != 8:
		levellist.erase(levelChoice)
		levelCount += 1
		return levelChoice
	elif levelCount == 4:
		return 4
	elif levelCount == 8:
		return 8

func levelListRemove():
	levellist.erase(levelChoice)

