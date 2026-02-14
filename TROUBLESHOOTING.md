# Troubleshooting Guide - Решавање Проблеми

## Вообичаени Проблеми и Решенија

### 1. Проектот не се отвора во Godot

**Проблем**: Godot пријавува грешка при отворање на проектот.

**Решение**:
- Проверете дали користите Godot 4.x (не 3.x)
- Проверете дали сте избрале `project.godot` файл
- Проверете дали сите фајлови се преземени правилно

### 2. Играчот не се движи

**Проблем**: Притискањето на WASD не го движи играчот.

**Решение**:
- Проверете дали сцената `scenes/main.tscn` е отворена
- Проверете дали е притисната Play копчето (F5)
- Проверете дали се генерира `.godot` папката (Godot ја креира автоматски)

### 3. UI не се прикажува

**Проблем**: HUD или екраните не се видливи.

**Решение**:
- Проверете дали `scenes/main.tscn` ги вклучува UI сцените
- Проверете дали GameManager е правилно поставен како AutoLoad
- Рестартирајте го Godot

### 4. Collectibles не исчезнуваат

**Проблем**: Играчот ги допира предметите но тие не исчезнуваат.

**Решение**:
- Проверете дали играчот е во "player" група
  - Отворете `scenes/player.tscn`
  - Кликнете на Player node
  - Во Inspector -> Groups -> проверете дали има "player"
- Проверете дали GameManager е активен (AutoLoad)

### 5. Загаденоста не се зголемува

**Проблем**: Загаденоста остана на 0%.

**Решение**:
- Проверете дали GameManager е правилно конфигуриран
- Проверете дали `game_over` или `victory` не се веќе `true`
- Рестартирајте ја играта

### 6. Станицата не се активира

**Проблем**: Притискање на E не работи.

**Решение**:
- Проверете дали сте собрале **сите** 12 предмети
- Проверете дали сте доволно близу до станицата
- Проверете дали Input action "activate" е дефинирана за E

### 7. Камерата не го следи играчот

**Проблем**: Камерата е статична.

**Решение**:
- Камерата е child node на играчот, па автоматски го следи
- Проверете дали Camera3D е дете на Player во `scenes/player.tscn`

### 8. Играта е премногу тешка/лесна

**Решение за ТЕШКО**:
- Отворете `scripts/game_manager.gd`
- Променете `POLLUTION_INCREASE_RATE` на помала вредност (пр. 3.0)
- Променете `TOXIC_CLOUD_PENALTY` на помала вредност (пр. 10.0)

**Решение за ЛЕСНО**:
- Зголемете ги истите вредности (пр. 8.0 и 20.0)

### 9. Токсичните облаци не се движат

**Проблем**: Облаците се статични.

**Решение**:
- Проверете дали `scripts/toxic_cloud.gd` има `_process(delta)` метод
- Проверете дали `move_speed` и `move_distance` не се 0
- Рестартирајте ја сцената

### 10. Екраните за победа/пораз не се прикажуваат

**Проблем**: Играта завршува но екранот не се појавува.

**Решение**:
- Проверете дали `scenes/ui/victory_screen.tscn` и `defeat_screen.tscn` се вклучени во `main.tscn`
- Проверете дали `visible = false` на почеток
- Проверете дали сигналите се поврзани правилно во `_ready()`

## Проверка на Конфигурација

### Проверка на AutoLoad
1. Project -> Project Settings -> AutoLoad
2. Проверете дали `GameManager` е во листата
3. Path треба да биде: `res://scripts/game_manager.gd`
4. Треба да има звездичка (*) за singleton

### Проверка на Input Actions
1. Project -> Project Settings -> Input Map
2. Проверете дали се дефинирани:
   - move_forward (W, Arrow Up)
   - move_backward (S, Arrow Down)
   - move_left (A, Arrow Left)
   - move_right (D, Arrow Right)
   - jump (Space)
   - activate (E)

### Проверка на Main Scene
1. Project -> Project Settings -> Application -> Run
2. Main Scene треба да биде: `res://scenes/main.tscn`

## Дебагирање

### Користење на Print Statements
Додадете print() во код за дебагирање:

```gdscript
# Во player.gd
func _physics_process(delta):
    print("Player position: ", global_position)
    # ...

# Во collectible.gd
func _on_body_entered(body):
    print("Body entered: ", body.name)
    # ...

# Во game_manager.gd
func collect_item():
    print("Item collected! Total: ", collected_items)
    # ...
```

### Користење на Godot Debugger
1. Отворете сцена
2. Притиснете F5 за Play
3. Користете Output таб за да видите print пораки
4. Користете Debugger таб за да видите грешки

### Проверка на Групи
Проверете дали објектите се во правилни групи:
- Player -> "player" група
- Collectibles -> "collectible" група

Како да додадете:
1. Изберете node
2. Inspector -> Node -> Groups
3. Внесете име на група
4. Add

## Перформанси

### Ако играта е бавна:
1. Намалете број на collectibles (отстранете некои)
2. Намалете број на токсични облаци
3. Поедноставете материјали (remove transparency)

### Како да отстраните објект:
1. Отворете `scenes/main.tscn`
2. Изберете објект од Scene tree
3. Delete
4. Save

## Сигнали и Конекции

### Проверка на Signal конекции:
1. Изберете node
2. Inspector -> Node -> Signals
3. Проверете дали потребните сигнали се поврзани

### Повторно поврзување на сигнал:
```gdscript
# Во _ready() функција:
GameManager.game_won.connect(_on_game_won)
GameManager.game_lost.connect(_on_game_lost)
```

## Контакт за Помош

Ако проблемот продолжува:
1. Проверете ја Godot документацијата: https://docs.godotengine.org
2. Проверете ја `DOCUMENTATION.md` за технички детали
3. Проверете ја `FLOWCHART.md` за структура на играта

## Чести Прашања (FAQ)

**Q: Може ли да додадам повеќе предмети?**
A: Да, дуплицирајте collectible node во `scenes/main.tscn` и поставете го на нова позиција.

**Q: Може ли да променам бои на објектите?**
A: Да, изберете MeshInstance3D -> Inspector -> Material -> Albedo Color.

**Q: Може ли да променам брзина на играчот?**
A: Да, во `scripts/player.gd` променете го `SPEED = 5.0`.

**Q: Може ли да додадам нови нивоа?**
A: Да, дуплицирајте `scenes/main.tscn`, уредете го, и променете Main Scene во Project Settings.

**Q: Како да додадам звуци?**
A: Додадете AudioStreamPlayer nodes и конектирајте ги на соодветните настани.
