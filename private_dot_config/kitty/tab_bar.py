from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title

# ── Tokyo Night palette ────────────────────────────────────────────────────────
BAR_BG = as_rgb(0x16161E)  # tab bar background
ACTIVE_BG = as_rgb(0x7AA2F7)  # active tab fill  (blue)
ACTIVE_FG = as_rgb(0x1A1B26)  # active tab text  (dark)
INACTIVE_BG = as_rgb(0x24283B)  # inactive tab fill
INACTIVE_FG = as_rgb(0x565F89)  # inactive tab text
BELL_FG = as_rgb(0xF7768E)  # bell indicator   (red)
ACTIVITY_FG = as_rgb(0xE0AF68)  # activity dot     (yellow)

# ── Nerd Font glyphs ──────────────────────────────────────────────────────────
LEFT_CAP = "\ue0b6"  # rounded left
RIGHT_CAP = "\ue0b4"  # rounded right
BELL_ICON = "\uf0f3 "  # 󰂚
DOT = "● "


def _set_colors(screen: Screen, fg: int, bg: int) -> None:
    screen.cursor.fg = fg
    screen.cursor.bg = bg


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    tab_bg = ACTIVE_BG if tab.is_active else INACTIVE_BG
    tab_fg = ACTIVE_FG if tab.is_active else INACTIVE_FG

    # ── Left pill cap ─────────────────────────────────────────────────────────
    _set_colors(screen, tab_bg, BAR_BG)
    screen.draw(LEFT_CAP)

    # ── Tab body ──────────────────────────────────────────────────────────────
    _set_colors(screen, tab_fg, tab_bg)
    screen.draw(" ")

    # Bell / activity indicators (colored inline)
    if tab.needs_attention:
        _set_colors(screen, BELL_FG, tab_bg)
        screen.draw(BELL_ICON)
        _set_colors(screen, tab_fg, tab_bg)
    elif tab.has_activity_since_last_focus and not tab.is_active:
        _set_colors(screen, ACTIVITY_FG, tab_bg)
        screen.draw(DOT)
        _set_colors(screen, tab_fg, tab_bg)

    # Index + title
    prefix = f"{index}: "
    screen.draw(prefix)
    draw_title(
        draw_data, screen, tab, index, max(1, max_title_length - len(prefix) - 4)
    )
    screen.draw(" ")

    # ── Right pill cap ────────────────────────────────────────────────────────
    _set_colors(screen, tab_bg, BAR_BG)
    screen.draw(RIGHT_CAP)

    # ── Gap between pills ─────────────────────────────────────────────────────
    _set_colors(screen, BAR_BG, BAR_BG)
    screen.draw(" ")

    return screen.cursor.x
