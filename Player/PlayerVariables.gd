extends Node2D

class_name PlayerClass
var playerName = ""
var playerFlag = ""
var gold = 10
var food = 10

#Vector2(x,y),ilość tur. 2 tury na "rozgrzanie", 5 tur działania. Startowa wartość = 7
var foodFields = [] #Tablica, która przechowuje za ile ma się zamienić farma w działającą
var castleFields = [] #Tablica, która przechowuje miejsca zamków
var units = []
var castles = []

var additionalAttack = 0
var additionalDefense = 0
var faith = 0
var additionalFood = 0
var additionalGold = 0

