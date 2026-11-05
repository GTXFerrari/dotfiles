import re

from kitty.fast_data_types import Screen, wcswidth
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    apply_title_template,
    as_rgb,
    color_as_int,
    draw_attributed_string,
    truncate_line,
)

LEFT_CAP = "\ue0b6"  # rounded left
RIGHT_CAP = "\ue0b4"  # rounded right
# Keep the escape character used for colors. Other control characters can move the cursor.
TITLE_CONTROLS = re.compile(r"[\x00-\x1a\x1c-\x1f\x7f-\x9f]")


def _set_colors(screen: Screen, fg: int, bg: int) -> None:
    screen.cursor.fg = fg
    screen.cursor.bg = bg


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    width = min(max_tab_length, screen.columns - before)
    if width < 1:
        return before - 1

    gap = " " if not is_last and width > 1 else ""
    pill_width = width - len(gap)
    # Reserve two caps and two spaces when there is still room for "1: …".
    title_width = pill_width - 4 if pill_width >= 8 else pill_width
    if draw_data.max_tab_title_length > 0:
        title_width = min(title_width, draw_data.max_tab_title_length)

    # An unfocused split can report activity inside the active tab.
    if tab.is_active and tab.has_activity_since_last_focus:
        tab = tab._replace(has_activity_since_last_focus=False)
    title = apply_title_template(draw_data, tab, index, title_width)
    line, newline, _ = title.partition("\n")
    line = TITLE_CONTROLS.sub(" ", line)
    if newline or wcswidth(line) > title_width:
        line = truncate_line(line, title_width)

    rounded = wcswidth(line) + 4 <= pill_width
    padding = " " if rounded else ""
    bar_bg = as_rgb(color_as_int(draw_data.default_bg))
    tab_bg = as_rgb(draw_data.tab_bg(tab))
    tab_fg = as_rgb(draw_data.tab_fg(tab))

    if rounded:
        _set_colors(screen, tab_bg, bar_bg)
        screen.draw(LEFT_CAP)
    _set_colors(screen, tab_fg, tab_bg)
    draw_attributed_string(padding + line + padding, screen)
    if rounded:
        _set_colors(screen, tab_bg, bar_bg)
        screen.draw(RIGHT_CAP)
    if gap:
        _set_colors(screen, bar_bg, bar_bg)
        screen.draw(gap)

    # Kitty treats the end of the click target as inclusive.
    return screen.cursor.x - 1
