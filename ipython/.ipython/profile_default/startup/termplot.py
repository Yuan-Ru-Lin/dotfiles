"""Inline matplotlib figures via Kitty graphics protocol + IPython workflow.

Drop into ~/.ipython/profile_default/startup/ (any *.py filename).

A self-contained replacement for the mpltermimg matplotlib backend, plus
IPython REPL ergonomics:

- Anonymous figures (plt.plot(...)) are shown and closed at cell end.
- Named figures (fig, ax = plt.subplots()) are kept alive and detached
  from pyplot's current-figure stack, so subsequent plt.plot() calls
  create new figures.
- Evaluating a Figure at the prompt renders its current state.
- fig.show() and plt.show() route to the inline renderer naturally,
  since we register a real matplotlib backend (no monkey-patching).
"""
import sys
import types


def _setup():
    try:
        from IPython import get_ipython
    except ImportError:
        return
    ip = get_ipython()
    if ip is None or type(ip).__name__ != 'TerminalInteractiveShell':
        return

    from base64 import b64encode
    from io import BytesIO
    from matplotlib.backend_bases import FigureManagerBase
    from matplotlib.backends.backend_agg import FigureCanvasAgg

    CHUNK_SIZE = 4096
    BACKEND_NAME = '_inline_kitty_backend'

    def emit_kitty(data):
        encoded = b64encode(data).decode('ascii')
        first, rest = encoded[:CHUNK_SIZE], encoded[CHUNK_SIZE:]
        sys.stdout.write(f"\033_Gm={'1' if rest else '0'},a=T,f=100;{first}\033\\")
        while rest:
            chunk, rest = rest[:CHUNK_SIZE], rest[CHUNK_SIZE:]
            sys.stdout.write(f"\033_Gm={'1' if rest else '0'};{chunk}\033\\")
        sys.stdout.write('\n')
        sys.stdout.flush()

    class FigureManager(FigureManagerBase):
        def show(self):
            buf = BytesIO()
            self.canvas.print_png(buf)
            emit_kitty(buf.getvalue())

    class FigureCanvas(FigureCanvasAgg):
        manager_class = FigureManager

    # Register a synthetic backend module so matplotlib's normal backend
    # machinery handles fig.show() / plt.show() for us.
    mod = types.ModuleType(BACKEND_NAME)
    mod.FigureCanvas = FigureCanvas
    mod.FigureManager = FigureManager
    sys.modules[BACKEND_NAME] = mod

    import matplotlib
    matplotlib.use(f'module://{BACKEND_NAME}')

    import matplotlib.pyplot as plt
    from matplotlib._pylab_helpers import Gcf

    def auto_show(_):
        held = {id(v) for v in ip.user_ns.values() if isinstance(v, plt.Figure)}
        for manager in list(Gcf.get_all_fig_managers()):
            fig = manager.canvas.figure
            if id(fig) not in held:
                manager.show()
                plt.close(fig)
            else:
                # Keep the figure alive but detach from pyplot's stack,
                # so subsequent plt.plot() starts a fresh figure.
                Gcf.figs.pop(manager.num, None)

    def show_fig(fig, *args, **kwargs):
        fig.canvas.draw()
        fig.canvas.manager.show()
        return ''

    ip.events.register('post_run_cell', auto_show)
    ip.display_formatter.formatters['text/plain'].for_type(plt.Figure, show_fig)


_setup()
del _setup
