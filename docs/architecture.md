# Trevor — Architecture

## Overview

Trevor is a Flutter monorepo structured so that every mini-game is a self-contained Dart package. The main app (`trevor_app`) is a thin shell that hosts the games and provides navigation.

```
trevor/
├── apps/
│   └── trevor_app/          # Main Flutter app (shell + navigation)
│
├── packages/
│   ├── balloon_pop/         # 🎈 Balloon Pop mini-game
│   ├── shared_ui/           # Theme, widgets, animations
│   ├── shared_audio/        # AudioService + SoundId registry
│   ├── shared_models/       # Data models (BalloonType, GameProgress…)
│   └── shared_utils/        # RandomUtils, HapticUtils
│
├── assets/                  # All images, audio, fonts, animations
└── docs/                    # This file and other documentation
```

## Dependency Graph

```
trevor_app
  ├── balloon_pop
  │     ├── shared_ui
  │     ├── shared_audio
  │     └── shared_models
  ├── shared_ui
  ├── shared_audio
  ├── shared_models
  └── shared_utils
```

`shared_models` has no intra-repo dependencies — it is the foundation layer.

## State Management

**Riverpod** is used throughout. Each mini-game owns its own `Notifier` provider. The providers are scoped inside each game's route via `ProviderScope` overrides so that game state resets on every visit.

## Navigation

**go_router** handles routing in `trevor_app`. Routes:

| Path            | Screen              |
|-----------------|---------------------|
| `/`             | Trevor's Room       |
| `/balloon-pop`  | Balloon Pop game    |

Route transitions use fade animations to keep context clear for young children.

## Audio

`AudioService` (in `shared_audio`) wraps `audioplayers`. It maintains:
- One looping `AudioPlayer` for background music.
- A pool of short-lived `AudioPlayer` instances for SFX.

The service is provided via `audioServiceProvider` (Riverpod).

## Storage

**Hive** stores `GameProgress` per game. Keys match `GameId.name` strings.

## Design Principles

- Portrait-only — consistent layout on all devices.
- Immersive mode — no system UI distractions.
- No network calls — fully offline.
- No ads, no IAPs.
- No "Game Over" — positive reinforcement only.
