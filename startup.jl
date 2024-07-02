try
    using Revise, OhMyREPL, Debugger
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end
