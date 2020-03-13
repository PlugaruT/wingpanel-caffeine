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

public class Caffeine.Indicator : Wingpanel.Indicator {
    const string APPNAME = "com.github.plugarut.wingpanel-caffeine";

    private Wingpanel.Widgets.OverlayIcon icon;
    private Gtk.Grid popover_widget;
    
    private Settings power_settings;
    private Settings session_settings;
    private Settings dpms_settings;

    public string sleep_settings_ac { get; set; }
    public string sleep_settings_bat { get; set; }
    public bool idle_dim { get; set; }
    public uint session_timeout { get; set; }
    public int standby_time {get; set; }

    public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (
            code_name: APPNAME,
            display_name: _ ("Wingpanel Caffeine"),
            description: _ ("Caffeine for elementary")
            );
        visible = true;
    }
    
    construct {
        Gtk.IconTheme.get_default ().add_resource_path ("/com/github/plugarut/wingpanel-caffeine/icons");
        icon = new Wingpanel.Widgets.OverlayIcon ("caffeine-off-symbolic");

        var toggle_switch = new Wingpanel.Widgets.Switch (_("Prevent Sleep"));

        popover_widget = new Gtk.Grid ();
        popover_widget.add (toggle_switch);

        var settings = new Settings("com.github.plugarut.wingpanel-caffeine");

        power_settings = new Settings("org.gnome.settings-daemon.plugins.power");
        session_settings = new Settings("org.gnome.desktop.session");
        dpms_settings = new Settings("io.elementary.dpms");

        settings.bind("ac-type", this, "sleep_settings_ac", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("bat-type", this, "sleep_settings_bat", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("dim-on-idle", this, "idle_dim", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("session-timeout", this, "session_timeout", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("standby-time", this, "standby_time", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("active", toggle_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        update_icon (toggle_switch.active);

        toggle_switch.notify["active"].connect (() => {
            update_icon (toggle_switch.active);
            if (toggle_switch.active) {
                save_current_sleep_settings ();
                disable_sleep_settings ();
            } else {
                restore_sleep_settings ();
            }
        });
    }
    
    private void update_icon (bool show_overlay) {
        if (show_overlay){
            icon.set_overlay_icon_name ("caffeine-on-symbolic");
        } else {
            icon.set_overlay_icon_name ("");
        }
    }

    private void save_current_sleep_settings () {
        this.sleep_settings_ac = power_settings.get_string("sleep-inactive-ac-type");
        this.sleep_settings_bat = power_settings.get_string("sleep-inactive-battery-type");
        this.idle_dim = power_settings.get_boolean("idle-dim");
        this.session_timeout = session_settings.get_uint("idle-delay");
        this.standby_time = dpms_settings.get_int("standby-time");
    }
    
    private void disable_sleep_settings () {
        power_settings.set_string("sleep-inactive-ac-type", "nothing");
        power_settings.set_string("sleep-inactive-battery-type", "nothing");
        power_settings.set_boolean("idle-dim", false);
        session_settings.set_uint("idle-delay", 0);
        dpms_settings.set_int("standby-time", 0);
    }
    
    private void restore_sleep_settings () {
        power_settings.set_string("sleep-inactive-ac-type", this.sleep_settings_ac);
        power_settings.set_string("sleep-inactive-battery-type", this.sleep_settings_bat);
        power_settings.set_boolean("idle-dim", this.idle_dim);
        session_settings.set_uint("idle-delay", this.session_timeout);
        dpms_settings.set_int("standby-time", this.standby_time);
    }
    
    public override Gtk.Widget get_display_widget () {
        return icon;
    }

    public override Gtk.Widget ? get_widget () {
        return popover_widget;
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

    var indicator = new Caffeine.Indicator (server_type);

    return indicator;
}
