extends Node

#region Constants

#region Characters


const AIAUTUMN = preload("res://Scenes/Characters/Autumn/AIAutumn.tscn")
const FUYUKITAMANEKO = preload("res://Scenes/Characters/Tamaneko/FuyukiTamaneko.tscn")

const WARRIOR = preload("res://Scenes/Characters/Adventurers/Warrior.tscn")
const WIZARD = preload("res://Scenes/Characters/Adventurers/Wizard.tscn")


const BLUESLIME = preload("res://Scenes/Characters/BlueSlime/Blueslime.tscn")


#endregion

#endregion


#region Signals

signal AttackMade(Attacker:CharacterBody2D, Attacked:CharacterBody2D, Damage)
signal MonsterKilled(Killer, XPValue: int, GoldValue: int)


#endregion
