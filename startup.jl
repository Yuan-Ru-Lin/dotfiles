try
    @eval using Revise
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

try
    @eval using OhMyREPL
    @async begin
        # See also https://github.com/KristofferC/OhMyREPL.jl/issues/166
        sleep(1)
        OhMyREPL.Prompt.insert_keybindings()
    end
catch e
    @warn "Error initializing OhMyREPL" exception=(e, catch_backtrace())
end

const PLOTS_DEFAULTS = Dict(
    :label => nothing,
    # Dismiss legend border
    :legend_foreground_color => :transparent,
    # Align the buttom and the left margin of the plot on the x/y-axis
    :xlim => (-Inf, Inf), :ylim => (-Inf, Inf),
    :grid => false,
    :linewidth => 1.5,
    :dpi => 600,
)
