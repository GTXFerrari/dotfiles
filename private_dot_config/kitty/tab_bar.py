from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    color_as_int,
    draw_title,
)

# Theme-driven accents. The tab body colors come from Kitty's resolved
# active_tab_* and inactive_tab_* options, so included themes can control them.
BELL_FG = as_rgb(0xFFB4AB)
ACTIVITY_FG = as_rgb(0xC2C5DD)

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
    bar_bg = as_rgb(color_as_int(draw_data.default_bg))
    tab_bg = as_rgb(draw_data.tab_bg(tab))
    tab_fg = as_rgb(draw_data.tab_fg(tab))

    # ── Left pill cap ─────────────────────────────────────────────────────────
    _set_colors(screen, tab_bg, bar_bg)
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
    _set_colors(screen, tab_bg, bar_bg)
    screen.draw(RIGHT_CAP)

    # ── Gap between pills ─────────────────────────────────────────────────────
    _set_colors(screen, bar_bg, bar_bg)
    screen.draw(" ")

    return screen.cursor.x
