extends Node

const DUST_EFFECT = preload("uid://56qwi47740dt")
const HIT_PARTICLES = preload("uid://bm80prn7vv40f")

signal camera_shook( strength : float )


# create dust effects
# create new instance of a dust effect
func _create_dust_effect( pos : Vector2 ) -> DustEffect:
	# create new dust instance
	var dust : DustEffect = DUST_EFFECT.instantiate()
	# add it to the scene tree
	add_child( dust )
	# position node
	dust.global_position = pos
	# return to node
	return dust


# create jump dust
func jump_dust( pos : Vector2 ) -> void:
	var dust : DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.JUMP )
	pass


# create land dust
func land_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.LAND )
	pass


# create hit dust
func hit_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.HIT )
	pass


# creste hit particles
func hit_particles( pos : Vector2, dir : Vector2, settings : HitParticleSettings ) -> void:
	var p : HitParticles = HIT_PARTICLES.instantiate()
	add_child( p )
	p.global_position = pos
	p.start( dir, settings )
	pass


func camera_shake( strength : float = 1.0 ) -> void:
	camera_shook.emit( strength )
	pass
	
