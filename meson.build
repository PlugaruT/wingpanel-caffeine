project('com.github.plugarut.wingpanel-caffeine', 'vala', 'c')

gettext_name = meson.project_name() + '-indicator'
gnome = import('gnome')
i18n = import('i18n')

# common dirs
prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
libdir = join_paths(prefix, get_option('libdir'))

# add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

wingpanel_dep = dependency('wingpanel-2.0')

icons_gresource = gnome.compile_resources(
    'gresource_icons',
    'data/icons.indicator.gresource.xml',
    source_dir: 'data/',
    c_name: 'as'
)

shared_module(
    'wingpanel-caffeine',
    'src/Indicator.vala',
    icons_gresource,
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        wingpanel_dep
    ],
    vala_args: [
            '--vapidir=' + meson.source_root() + '/vapi/',
          ],
    install: true,
    install_dir : wingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir]),
)

subdir('data')

meson.add_install_script('post_install.py')
