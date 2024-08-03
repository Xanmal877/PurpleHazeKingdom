class_name BehaviorTreeBase extends TaskTestTree


func _physics_process(_delta):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUseState(get_parent()):
				child.UseActionBasedonState(get_parent())
				return

