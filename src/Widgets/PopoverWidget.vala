/*-
 * Copyright (c) 2018 Tudor Plugaru (https://github.com/PlugaruT/wingpanel-caffeine)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 * Authored by: Tudor Plugaru <plugaru.tudor@gmail.com>
 */

public class Caffeine.Widgets.PopoverWidget : Gtk.Grid {
    private Caffeine.Indicator indicator;

    public PopoverWidget (Caffeine.Indicator _indicator) {
        Object (orientation: Gtk.Orientation.VERTICAL);
        indicator = _indicator;
    }

    construct {
        var quit_button = new Gtk.ModelButton ();
        quit_button.text = _ ("Quit");
        quit_button.get_style_context ().add_class ("menuitem");
        quit_button.get_style_context ().remove_class ("button");
        add (quit_button);
    }
}
