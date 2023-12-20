extends Node2D

@onready var foodValue = $"../Console/food"
@onready var goldValue = $"../Console/gold"
var playerName = "Player #1"
var playerNumber = 0
var gold = 10
var food = 5

#Vector2(x,y),ilość tur. 2 tury na "rozgrzanie", 5 tur działania. Startowa wartość = 7
var foodFields = [] #Tablica, która przechowuje za ile ma się zamienić farma w działającą
var castleFields = [] #Tablica, która przechowuje miejsca zamków
 
