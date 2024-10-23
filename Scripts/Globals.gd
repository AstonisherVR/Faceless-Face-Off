extends Node

signal gameplay_stage_changed(current_gameplay_stage)

enum Gameplay_Stages {CALM, BEGGINING, FINAL}
var current_gameplay_stage := Gameplay_Stages.CALM
