# Trevor — Game Design Document

## Core Principles

| Principle | Implementation |
|-----------|----------------|
| **Simple** | A two-year-old should understand what to tap. No reading required on the main screen. |
| **Positive** | No "Game Over." No timers. No fail states. Always encouraging. |
| **Colorful** | Bright but not overwhelming. Friendly animations. Large tap targets (minimum 64×64 dp). |
| **Safe** | Offline-first. No ads. No external links. No user accounts. |

---

## Trevor's Room (Home Screen)

The home screen is Trevor's bedroom. Every game is a toy in the room.

```
        🪟  Window

  🧸 Teddy      📚 Bookshelf

  🎈 Balloons   🧩 Puzzle

  🎹 Piano      🎨 Paint

        🧒 Trevor
```

Children tap a toy to enter its game. Trevor bobs gently at the bottom as an anchor character.

---

## Balloon Pop

### Goal
Pop as many balloons as possible while having fun. No pressure, no losing.

### Gameplay Loop
1. Colorful balloons float upward from the bottom of the screen.
2. The child taps a balloon.
3. **POP!** — Stars appear, a cheerful sound plays.
4. Another balloon arrives.
5. Repeat forever.

### Balloon Types

| Type | Emoji | Points | Stars | Special Effect |
|------|-------|--------|-------|----------------|
| Red | 🎈 | 1 | ⭐ | Pop sound |
| Rainbow | 🌈 | 5 | ⭐⭐ | Confetti explosion |
| Golden | ⭐ | 10 | ⭐⭐⭐ | Special sound + big confetti |
| Gift | 🎁 | 3 | ⭐ | Surprise animation |
| Animal | 🐻 | 3 | ⭐ | Animal appears, says its name |

### Spawn Weights (relative probability)

| Type | Weight |
|------|--------|
| Red | 55% |
| Rainbow | 20% |
| Gift | 10% |
| Animal | 10% |
| Golden | 5% |

### Future — Learning Mode

Balloons display letters (A, B, C…) or numbers (1, 2, 3…). Tapping a balloon says its name and a word that starts with it:
> "A says **Apple**!" 🍎

This converts Balloon Pop into an educational tool without changing the core gameplay feel.

---

## Future Games

| Game | Description | Key Learning |
|------|-------------|--------------|
| Memory Match | Flip cards to find pairs | Memory, concentration |
| Animal Adventure | Animals appear, say their name | Animal names, sounds |
| ABC Explorer | Balloons with letters | Alphabet, phonics |
| Numbers | Count objects, tap the number | Counting 1–10 |
| Coloring | Tap areas to fill with color | Colors, creativity |
| Music Playground | Tap instruments to play notes | Cause and effect |
| Puzzle Time | Drag pieces to complete simple pictures | Spatial reasoning |
| Shape Builder | Identify and place shapes | Geometry basics |
| Hidden Objects | Find hidden items in a scene | Observation |
| Story Time | Tap characters to hear narrated stories | Language, imagination |

---

## Feedback & Reinforcement

Every positive action triggers at least one of:
- ✨ A visual animation (stars, confetti, bounce)
- 🔊 A cheerful sound effect
- 📳 Haptic feedback
- 💬 An encouraging phrase ("Great job!", "You're amazing!")

Negative states are never shown. If a balloon floats away untouched, it simply disappears — no penalty, no sound.
