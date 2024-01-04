extends Node2D

class_name PlayerClass
var playerName = ""
var playerFlag = ""
var gold = 10000
var food = 10000

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
#liczba pozwala na. no kurwa wiesz jaka jest obecnie cywilzacja i im mniejsze liczba tym gorszy itd.
var numberCivilization = 0

