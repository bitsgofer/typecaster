use godot::engine::Area2D;
use godot::prelude::*;

struct TypeCaster;

#[gdextension]
unsafe impl ExtensionLibrary for TypeCaster {}

/// Spell is an object that flies toward a target.
///
/// Spell is a top-level object that flies towards a configured target
/// (i.e: homing-missle style).
/// All Spell objects flying towards the same target (identified by name)
/// belongs to the same group.
#[derive(GodotClass)]
#[class(base=Node2D)]
struct Spell {
    #[var]
    entity_type: GodotString,
    #[var]
    speed: i64,
    /// Enemy node
    #[var]
    target: Option<Gd<Node2D>>,

    #[base]
    base: Base<Node2D>,
}

#[godot_api]
impl Node2DVirtual for Spell {
    fn init(base: Base<Node2D>) -> Self {
        Self {
            entity_type: "spell".into(),
            speed: 200,
            target: None,
            base,
        }
    }

    fn enter_tree(&mut self) {
        self.join_group();
    }

    fn ready(&mut self) {
        self.target.as_ref().map(|target| {
            godot_print!(
                "SPELL.V(2): spell/{} (target={}): spawned @ ({}, {})",
                self.base.get_name(),
                target.get_name(),
                self.base.get_position().x,
                self.base.get_position().y,
            )
        });
        self.base
            .get_node("Spell".into())
            .map(|mut node| node.connect("area_entered".into(), self.base.callable("on_hit")));
    }

    fn process(&mut self, delta: f64) {
        self.move_towards_top_level_target(delta);
    }
}

#[godot_api]
impl Spell {
    #[func]
    fn configure(&mut self, global_position: Vector2, target: Gd<Node2D>, speed: i64) {
        self.base.set_position(global_position);
        self.speed = speed;
        self.target = Some(target);
    }

    fn join_group(&mut self) {
        match self.target {
            None => godot_print!(
                "SPELL.V(4): spell/{} (target=null): self.target is null => skip joining group",
                self.base.get_name(),
            ),
            Some(ref target) => {
                let key = self.get_group_key();
                self.base.add_to_group(key.clone());
                godot_print!(
                    "SPELL.V(3): spell/{} (target={}): joined group {}",
                    self.base.get_name(),
                    target.get_name(),
                    key,
                );
            }
        }
    }

    #[func]
    fn get_group_key(&self) -> StringName {
        self.target
            .as_ref()
            .map(|target| format!("spell(target=enemy/{})", target.get_name()).into())
            .unwrap_or_else(|| "spell(target=enemy/null)".into())
    }

    #[func]
    fn on_hit(&self, area: Gd<Area2D>) {
        if area.get_name() != "Enemy".into() {
            godot_print!(
                "SPELL.V(3): hit by unhandled area (name={})",
                area.get_name(),
            );
            return;
        }
        godot_print!("SPELL.V(2): hit by an enemy");
    }

    /// move towards a target by its global position
    fn move_towards_top_level_target(&mut self, delta: f64) {
        match self.target {
            None => godot_print!(
                "SPELL.V(4): spell/{} (target=null): self.target is null => skip moving",
                self.base.get_name(),
            ),
            Some(ref target) => {
                let position = self.base.get_position();
                let direction = target.get_global_position() - position;
                let new_position =
                    position + direction.normalized() * (self.speed as f64 * delta) as f32;
                self.base.set_position(new_position);
            }
        }
    }
}
