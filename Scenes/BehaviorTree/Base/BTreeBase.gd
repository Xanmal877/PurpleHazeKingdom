class_name BehaviorTreeBase extends TaskTestTree


func _physics_process(_delta):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUsePhysics(get_parent()):
				child.UseActionPhysics(get_parent())
				return

