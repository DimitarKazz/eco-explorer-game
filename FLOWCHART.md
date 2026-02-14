# Игра Флоу Дијаграм

```
┌─────────────────────────────────────────────────────────┐
│                    СТАРТ НА ИГРА                        │
│                   (scenes/main.tscn)                    │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│              Иницијализација                            │
│  - GameManager.total_items = 12                         │
│  - GameManager.reset_game()                             │
│  - HUD се поврзува со сигнали                          │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
         ┌─────────────────────────┐
         │    ГЛАВНА ИГРА ПЕТЉА   │
         └─────────────┬───────────┘
                       │
         ┌─────────────▼──────────────┐
         │   Загаденост += 5%/сек     │
         └─────────────┬──────────────┘
                       │
         ┌─────────────▼──────────────┐
         │  Играч се движи (WASD)     │
         │  Играч скока (Space)       │
         └─────────────┬──────────────┘
                       │
         ┌─────────────▼──────────────┐
         │   Токсични облаци патролат │
         └─────────────┬──────────────┘
                       │
         ┌─────────────▼──────────────┐
         │     Детекција на допири    │
         └──┬──────────┬──────────┬───┘
            │          │          │
    ┌───────▼────┐ ┌──▼──────┐  │
    │ Collectible│ │  Cloud  │  │
    │  собрано   │ │ +15% заг│  │
    └───────┬────┘ └──┬──────┘  │
            │         │          │
            ▼         ▼          │
    ┌──────────────────┐         │
    │ UI се ажурира    │         │
    └──────────────────┘         │
                                 │
         ┌───────────────────────▼─────────────────────┐
         │           УСЛОВИ ЗА КРАЈ                    │
         └──────┬──────────────────────┬───────────────┘
                │                      │
    ┌───────────▼────────┐   ┌────────▼───────────┐
    │ Загаденост >= 100% │   │ Сите собрани +     │
    │                    │   │ Станица активирана │
    └───────────┬────────┘   └────────┬───────────┘
                │                     │
    ┌───────────▼────────┐   ┌────────▼───────────┐
    │   ПОРАЗ ЕКРАН      │   │   ПОБЕДА ЕКРАН     │
    │ "Преголемо         │   │ "Езерото е         │
    │  загадување!"      │   │  спасено!"         │
    └───────────┬────────┘   └────────┬───────────┘
                │                     │
                └─────────┬───────────┘
                          │
                ┌─────────▼──────────┐
                │  Restart копче     │
                │  притиснато?       │
                └─────────┬──────────┘
                          │
                ┌─────────▼──────────┐
                │ reload_current_    │
                │ scene()            │
                └────────────────────┘
```

## Компоненти и Нивна Комуникација

```
┌────────────────────────────────────────────────────────┐
│                    GameManager                         │
│                   (AutoLoad Singleton)                 │
│                                                        │
│  Променливи:                                          │
│  - pollution_level: float                             │
│  - collected_items: int                               │
│  - total_items: int                                   │
│  - game_over: bool                                    │
│  - victory: bool                                      │
│                                                        │
│  Методи:                                              │
│  - collect_item()                                     │
│  - increase_pollution_by_cloud()                      │
│  - can_activate_station()                             │
│  - activate_station()                                 │
│  - trigger_victory()                                  │
│  - trigger_defeat()                                   │
│  - reset_game()                                       │
└───┬────────────────────────────────────────────┬──────┘
    │                                            │
    │ emit signals                               │ emit signals
    │                                            │
┌───▼──────────┐  ┌──────────────┐  ┌──────────▼──────┐
│     HUD      │  │  Collectible │  │ Victory/Defeat  │
│              │  │              │  │     Screens     │
│ - Собрано    │  │ Area3D       │  │                 │
│ - Загаденост │  │ body_entered │  │ Restart Button  │
│ - Контроли   │  │ -> collect() │  │                 │
└──────────────┘  └──────────────┘  └─────────────────┘

┌─────────────┐  ┌──────────────┐  ┌─────────────────┐
│   Player    │  │ ToxicCloud   │  │  Purification   │
│             │  │              │  │    Station      │
│ WASD/Space  │  │ Area3D       │  │                 │
│ CharacterB. │  │ sin movement │  │ Area3D + E key  │
└─────────────┘  └──────────────┘  └─────────────────┘
```

## Физика и Детекција

```
┌─────────────────────────────────────────────────────┐
│                  Физика Слоеви                      │
├─────────────────────────────────────────────────────┤
│                                                     │
│  CharacterBody3D (Player)                          │
│    ↕ колидира со                                   │
│  StaticBody3D (Ground, Platforms)                  │
│                                                     │
│  Area3D (Collectibles, Clouds, Station)            │
│    ↕ детектира                                     │
│  CharacterBody3D (Player)                          │
│                                                     │
└─────────────────────────────────────────────────────┘

Детекција:
  body_entered(body):
    if body.is_in_group("player"):
      → trigger action
```

## UI Хиерархија

```
CanvasLayer (HUD)
  └─ Control
     ├─ VBoxContainer
     │  ├─ CollectedLabel  "Собрано: X/Y"
     │  ├─ PollutionLabel  "Загаденост: X%"
     │  └─ PollutionBar    [========>    ]
     └─ InstructionsLabel

CanvasLayer (VictoryScreen)
  └─ Panel
     └─ VBoxContainer
        ├─ TitleLabel     "ЕЗЕРОТО Е СПАСЕНО!"
        ├─ MessageLabel   "Честитки!"
        └─ RestartButton  [Играј повторно]

CanvasLayer (DefeatScreen)
  └─ Panel
     └─ VBoxContainer
        ├─ TitleLabel     "ПРЕГОЛЕМО ЗАГАДУВАЊЕ!"
        ├─ MessageLabel   "Обидете се повторно..."
        └─ RestartButton  [Обиди се повторно]
```

## 3D Хиерархија на Сцената

```
Main (Node3D)
  ├─ WorldEnvironment
  ├─ DirectionalLight3D
  ├─ Player (CharacterBody3D)
  │  ├─ MeshInstance3D (Capsule)
  │  ├─ CollisionShape3D
  │  └─ Camera3D
  ├─ Water (MeshInstance3D - Plane)
  ├─ Ground (MeshInstance3D + StaticBody3D)
  ├─ Platforms (Node3D)
  │  ├─ Platform1 (StaticBody3D)
  │  ├─ Platform2 (StaticBody3D)
  │  └─ Platform3 (StaticBody3D)
  ├─ Collectibles (Node3D)
  │  ├─ Collectible1..12 (Area3D)
  ├─ ToxicClouds (Node3D)
  │  ├─ ToxicCloud1..3 (Area3D)
  ├─ PurificationStation (Area3D)
  ├─ Environment (Node3D)
  │  ├─ Boat
  │  ├─ Barrels (Node3D)
  │  ├─ Reeds (Node3D)
  │  └─ Fish (MeshInstance3D + AnimationPlayer)
  ├─ HUD (CanvasLayer)
  ├─ VictoryScreen (CanvasLayer)
  └─ DefeatScreen (CanvasLayer)
```
