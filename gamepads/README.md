# Custom mapping support

Files in this directory allow you to remap the default keycodes or adjust the buttons mapping to suit particular scenarios. It can even be used for input controllers other than the Picade HAT although that can be a tad more tricky to set up, depending on what is needed.

For example you might want to adjust the keycode like so:

```python
KEYS = {
    ENTER: e.KEY_ENTER,
    ESCAPE: e.KEY_ESC,
    COIN: e.KEY_C,
    START: e.KEY_S,
    UP: e.KEY_UP,
    DOWN: e.KEY_DOWN,
    LEFT: e.KEY_LEFT,
    RIGHT: e.KEY_RIGHT,
    BUTTON1: e.KEY_A,
    BUTTON2: e.KEY_B,
    BUTTON3: e.KEY_C,
    BUTTON4: e.KEY_X,
    BUTTON5: e.KEY_Y,
    BUTTON6: e.KEY_Z
}
```

Once done, just run the `configload` script passing your config file name to it, like so:

`configload picadehat-custom`

The script will copy the file in place and restart the daemon. We advise that you restart the Pi nonetheless, to be sure the new settings are active before going any further.

If you paint yourself in a corner, just rerun the `setup.sh` one level up this repository, or run:

`configload picadehat-default`

For an exhaustive list of possible keycodes, see: https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h#L74
