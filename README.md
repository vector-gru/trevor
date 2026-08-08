# Trevor

### Play. Learn. Smile.

Trevor is an offline-first collection of fun and educational mini games for young children. Built with Flutter, it works on Android and iOS with no ads, no internet requirement, and no pressure to win — just fun.

This project is a tribute to my son, Trevor Noah.

---

## Trevor's Room

Every game is a toy in Trevor's room. Children tap an object to enter a game — no menus, no reading required.

```
         🪟  Window

  🧸 Teddy      📚 Bookshelf

  🎈 Balloons   🧩 Puzzle

  🎹 Piano      🎨 Paint

         🧒 Trevor
```

---

## Current Game

### 🎈 Balloon Pop

Pop colorful balloons, collect stars, enjoy cheerful sounds, and discover surprises. No losing — the game simply keeps going.

| Balloon    | Points | Special                 |
| ---------- | ------ | ----------------------- |
| 🎈 Red     | 1      | Pop sound               |
| 🌈 Rainbow | 5      | Confetti explosion      |
| ⭐ Golden  | 10     | Rare · bonus stars      |
| 🎁 Gift    | 3      | Surprise animation      |
| 🐻 Animal  | 3      | Friendly animal appears |

---

## Repository Structure

```
trevor/
├── apps/
│   └── trevor_app/          # Main Flutter app
│
├── packages/
│   ├── balloon_pop/         # 🎈 Balloon Pop game package
│   ├── shared_ui/           # Theme, widgets, animations
│   ├── shared_audio/        # Audio service
│   ├── shared_models/       # Data models
│   └── shared_utils/        # Utility helpers
│
├── assets/
│   ├── images/
│   ├── audio/
│   ├── fonts/
│   └── animations/
│
├── docs/
│   ├── roadmap.md
│   ├── game_design.md
│   └── architecture.md
│
└── README.md
```

---

## Tech Stack

| Library      | Purpose                        |
| ------------ | ------------------------------ |
| Flutter 3.x  | Cross-platform UI              |
| Riverpod     | State management               |
| go_router    | Navigation                     |
| Hive         | Local storage / progress       |
| audioplayers | Sound effects & music          |
| Lottie       | Celebration animations         |
| Rive         | Character animations (planned) |
| Melos        | Monorepo tooling               |

---

## Getting Started

### Prerequisites

- Flutter 3.44+
- Dart 3.12+

### Run the app

```bash
cd apps/trevor_app
flutter pub get
flutter run
```

> Note: always run Flutter commands from inside `apps/trevor_app`, not from the repo root.

### Using Melos (recommended)

```bash
dart pub global activate melos
melos bootstrap    # installs all package dependencies
melos get          # flutter pub get across all packages
melos analyze      # run analyzer across all packages
```

---

## Planned Games

- ✅ Balloon Pop
- ⏳ Memory Match
- ⏳ Animal Adventure
- ⏳ ABC Explorer
- ⏳ Numbers
- ⏳ Coloring
- ⏳ Music Playground
- ⏳ Puzzle Time
- ⏳ Trevor's Room (illustrated)

See [docs/roadmap.md](docs/roadmap.md) for details.

---

## Core Principles

- **Simple** — A two-year-old should understand what to tap.
- **Positive** — No "Game Over." Only encouragement.
- **Colorful** — Bright but not overwhelming. Large buttons.
- **Safe** — Offline. No ads. No accounts. No external links.

---

## Documentation

- [Architecture](docs/architecture.md)
- [Game Design](docs/game_design.md)
- [Roadmap](docs/roadmap.md)

---

## License

MIT
