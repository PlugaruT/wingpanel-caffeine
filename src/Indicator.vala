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

public class SysMonitor.Indicator : Wingpanel.Indicator {
    const string APPNAME = "wingpanel-caffeine";

    private SysMonitor.Widgets.DisplayWidget display_widget;


    public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (
            code_name: APPNAME,
            display_name: _ ("Wingpanel Caffeine"),
            description: _ ("Caffeine for elementary")
            );


    }

    public override Gtk.Widget get_display_widget () {
        if (display_widget == null) {
            display_widget = new SysMonitor.Widgets.DisplayWidget ();
            update ();
        }
        return display_widget;
    }

    public override Gtk.Widget ? get_widget () {
        return null;
    }

    public override void opened () { }

    public override void closed () { }
}

public Wingpanel.Indicator ? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
        debug ("Loading system monitor indicator");

    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        debug ("Wingpanel is not in session, not loading sys-monitor");
        return null;
    }

    var indicator = new SysMonitor.Indicator (server_type);

    return indicator;
}
