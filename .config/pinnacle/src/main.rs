use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Keysym;
use pinnacle_api::input::{Mod, MouseButton};
use pinnacle_api::layout;
use pinnacle_api::layout::LayoutGenerator;
use pinnacle_api::output;
use pinnacle_api::pinnacle;
use pinnacle_api::pinnacle::Backend;
use pinnacle_api::process::Command;
use pinnacle_api::signal::OutputSignal;
use pinnacle_api::signal::WindowSignal;
use pinnacle_api::tag;
use pinnacle_api::window;

async fn config() {
    // Change the mod key to `Alt` when running as a nested window.
    let mod_key = match pinnacle::backend() {
        Backend::Tty => Mod::SUPER,
        Backend::Window => Mod::ALT,
    };

    let terminal = "alacritty";

    //------------------------
    // Mousebinds            |
    //------------------------

    // `mod_key + left click` starts moving a window
    input::mousebind(mod_key, MouseButton::Left)
        .on_press(|| {
            window::begin_move(MouseButton::Left);
        })
        .group("Mouse")
        .description("Start an interactive window move");

    // `mod_key + right click` starts resizing a window
    input::mousebind(mod_key, MouseButton::Right)
        .on_press(|| {
            window::begin_resize(MouseButton::Right);
        })
        .group("Mouse")
        .description("Start an interactive window resize");

    //------------------------
    // Keybinds              |
    //------------------------

    input::keybind(mod_key, 'h')
        .on_press(|| {
            if let Some(win) = window::get_focused() && let Some(next) = win
                .in_direction(pinnacle_api::util::Direction::Left).next() {
                    next.set_focused(true);
            }
        });

    input::keybind(mod_key, 'l')
        .on_press(|| {
            if let Some(win) = window::get_focused() && let Some(next) = win
                .in_direction(pinnacle_api::util::Direction::Right).next() {
                    next.set_focused(true);
            }
        });

    input::keybind(mod_key, 'j')
        .on_press(|| {
            if let Some(win) = window::get_focused() && let Some(next) = win
                .in_direction(pinnacle_api::util::Direction::Down).next() {
                    next.set_focused(true);
            }
        });

    input::keybind(mod_key, 'k')
        .on_press(|| {
            if let Some(win) = window::get_focused() && let Some(next) = win
                .in_direction(pinnacle_api::util::Direction::Up).next() {
                    next.set_focused(true);
            }
        });

    // `mod_key + shift + e` quits Pinnacle
    input::keybind(mod_key | Mod::SHIFT, 'e')
        .set_as_quit()
        .group("Compositor")
        .description("Quit Pinnacle");
    //
    // `mod_key + shift + e` quits Pinnacle
    input::keybind(mod_key | Mod::SHIFT, 'q')
        .on_press(|| {
            Command::new("loginctl").args(["poweroff"]).spawn();
        })
        .group("Compositor")
        .description("Poweroff");

    // `mod_key + shift + r` reloads the config
    input::keybind(mod_key | Mod::SHIFT, 'r')
        .set_as_reload_config()
        .group("Compositor")
        .description("Reload the config");

    // `mod_key + shift + q` closes the focused window
    input::keybind(mod_key, 'q')
        .on_press(|| {
            if let Some(window) = window::get_focused() {
                window.close();
            }
        })
        .group("Window")
        .description("Close the focused window");

    input::keybind(mod_key, 'p')
        .on_press(move || {
            Command::new("bemenu-run").spawn();
        })
        .group("Process")
        .description("Spawn a bemenu");

    // `mod_key + shift + Return` spawns a terminal
    input::keybind(mod_key | Mod::SHIFT, Keysym::Return)
        .on_press(move || {
            Command::new(terminal).spawn();
        })
        .group("Process")
        .description("Spawn a terminal");

    // `mod_key + ctrl + t` toggles floating
    input::keybind(mod_key, 't')
        .on_press(|| {
            if let Some(window) = window::get_focused() {
                window.toggle_floating();
                window.raise();
            }
        })
        .group("Window")
        .description("Toggle floating on the focused window");

    // `mod_key + f` toggles fullscreen
    input::keybind(mod_key, 'f')
        .on_press(|| {
            if let Some(window) = window::get_focused() {
                window.toggle_fullscreen();
                window.raise();
            }
        })
        .group("Window")
        .description("Toggle fullscreen on the focused window");

    // `mod_key + m` toggles maximized
    input::keybind(mod_key, 'm')
        .on_press(|| {
            if let Some(window) = window::get_focused() {
                window.toggle_maximized();
                window.raise();
            }
        })
        .group("Window")
        .description("Toggle maximized on the focused window");

    // Media keybinds ------------------------------------------------------

    input::keybind(Mod::empty(), Keysym::XF86_AudioRaiseVolume)
        .on_press(|| {
            Command::new("volume.sh")
                .args(["up"])
                .spawn();
        }).allow_when_locked().group("Media")
        .description("Increase volume by 5%");

    input::keybind(Mod::empty(), Keysym::XF86_AudioLowerVolume)
        .on_press(|| {
            Command::new("volume.sh")
                .args(["down"])
                .spawn();
        }).allow_when_locked().group("Media")
        .description("Decrease volume by 5%");

    input::keybind(Mod::empty(), Keysym::XF86_AudioMute)
        .on_press(|| {
            Command::new("volume.sh")
                .args(["mute"])
                .spawn();
        }).allow_when_locked().group("Media").description("Toggle mute");

    input::keybind(Mod::empty(), Keysym::XF86_AudioMicMute)
        .on_press(|| {
            Command::new("wpctl")
                .args(["set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"])
                .spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Toggle mic mute");

    input::keybind(Mod::empty(), Keysym::XF86_AudioPlay)
        .on_press(|| {
            Command::new("playerctl").arg("play-pause").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Play/pause media");

    input::keybind(Mod::empty(), Keysym::XF86_AudioStop)
        .on_press(|| {
            Command::new("playerctl").arg("stop").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Stop media");

    input::keybind(Mod::empty(), Keysym::XF86_AudioNext)
        .on_press(|| {
            Command::new("playerctl").arg("next").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Go to next media");

    input::keybind(Mod::empty(), Keysym::XF86_AudioPrev)
        .on_press(|| {
            Command::new("playerctl").arg("previous").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Go to previous media");

    // Display brightness keybinds ----------------------------------------

    input::keybind(Mod::empty(), Keysym::XF86_MonBrightnessUp)
        .on_press(|| {
            Command::new("brightnessctl")
                .args(["--class=backlight", "set", "+10%"])
                .spawn();
        })
        .allow_when_locked()
        .group("Display")
        .description("Increase display brightness by 10%");

    input::keybind(Mod::empty(), Keysym::XF86_MonBrightnessDown)
        .on_press(|| {
            Command::new("brightnessctl")
                .args(["--class=backlight", "set", "10%-"])
                .spawn();
        })
        .allow_when_locked()
        .group("Display")
        .description("Decrease display brightness by 10%");

    //------------------------
    // Layouts               |
    //------------------------

    // Pinnacle supports a tree-based layout system built on layout nodes.
    //
    // To determine the tree used to layout windows, Pinnacle requests your config for a tree data structure
    // with nodes containing gaps, directions, etc. There are a few provided utilities for creating
    // a layout, known as layout generators.
    //
    // ### Layout generators ###
    // A layout generator is a table that holds some state as well as
    // the `layout` function, which takes in a window count and computes
    // a tree of layout nodes that determines how windows are laid out.
    //
    // There are currently six built-in layout generators, one of which delegates to other
    // generators as shown below.

    layout::manage(|layout_args| {
        let gaps = layout::Gaps {
            left: 0.0, right: 0.0, top: 0.0, bottom: 0.0
        };
        let master_stack = layout::generators::MasterStack {
            outer_gaps: gaps, inner_gaps: gaps, master_factor: 0.5,
            master_side: layout::generators::MasterSide::Left,
            reversed: true, master_count: 1
        };
        let root_node = master_stack.layout(layout_args.window_count);
        let tree_id = layout_args
            .tags
            .get(0)
            .map(|tag| tag.id())
            .unwrap_or_default();
        layout::LayoutResponse { root_node, tree_id }
    });

    //------------------------
    // Tags                  |
    //------------------------

    let tag_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

    // Setup all monitors with tags "1" through "9"
    output::for_each_output(move |output| {
        let mut tags = tag::add(output, tag_names);
        tags.next().unwrap().set_active(true);
    });

    if let Some(output) = output::get_focused() {
        output.set_mode(3840, 2160, 160000);
        output.set_vrr(output::Vrr::OnDemand);
    }

    for tag_name in tag_names {
        // `mod_key + 1-9` switches to tag "1" to "9"
        input::keybind(mod_key, tag_name)
            .on_press(move || {
                if let Some(tag) = tag::get(tag_name) {
                    tag.switch_to();
                }
            })
            .group("Tag")
            .description(format!("Switch to tag {tag_name}"));

        // `mod_key + shift + 1-9` moves the focused window to tag "1" to "9"
        input::keybind(mod_key | Mod::SHIFT, tag_name)
            .on_press(move || {
                if let Some(tag) = tag::get(tag_name)
                    && let Some(win) = window::get_focused()
                {
                    win.move_to_tag(&tag);
                }
            })
            .group("Tag")
            .description(format!("Move the focused window to tag {tag_name}"));
    }

    input::libinput::for_each_device(|device| {
        // Enable natural scroll for touchpads
        if device.device_type().is_touchpad() {
            device.set_natural_scroll(true);
            device.set_tap(true);
        } else if device.device_type().is_mouse() {
            device.set_accel_profile(input::libinput::AccelProfile::Flat);
            device.set_accel_speed(-0.6);
        }
    });

    // Enable focus borders with titlebars
    #[cfg(feature = "snowcap")]
    {
        use pinnacle_api::snowcap::FocusBorder;
        use pinnacle_api::experimental::snowcap_api;
        // Add borders to new windows.
        window::add_window_rule(move |window| {
            window.set_vrr_demand(window::VrrDemand::when_fullscreen());
            window.set_decoration_mode(window::DecorationMode::ServerSide);
            let mut border = FocusBorder::new(&window);
            border.thickness = 3;
            border.focused_color = snowcap_api::widget::Color::rgb(0.82, 0.85, 0.97);
            border.unfocused_color = snowcap_api::widget::Color::rgb(0.37, 0.37, 0.41);
            let _ = border.decorate();
            /*
            let _ = FocusBorder {
                window: window.clone(), thickness: 2,
                focused_color: snowcap_api::widget::Color::rgb(0.82, 0.85, 0.97),
                unfocused_color: snowcap_api::widget::Color::rgb(0.37, 0.37, 0.4),
                focused: window.focused(), include_titlebar: false,
                title: window.title(), titlebar_height: 0
            }.decorate();
            */
        });
    }

    // Enable sloppy focus
    window::connect_signal(WindowSignal::PointerEnter(Box::new(|win| {
        win.set_focused(true);
    })));

    // Focus outputs when the pointer enters them
    output::connect_signal(OutputSignal::PointerEnter(Box::new(|output| {
        output.focus();
    })));

    #[cfg(feature = "snowcap")]
    if let Some(error) = pinnacle_api::pinnacle::take_last_error() {
        // Show previous crash messages
        pinnacle_api::snowcap::ConfigCrashedMessage::new(error).show();
    } /* else {
        // Or show the bind overlay on startup
        pinnacle_api::snowcap::BindOverlay::new().show();
    }
    */

    Command::new("openrc").args(["-U", "pinnacle"]).once().spawn();
}

pinnacle_api::main!(config);
