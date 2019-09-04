module Bzip2_jll
using Pkg, Pkg.BinaryPlatforms, Pkg.Artifacts, Libdl
import Base: UUID

# Load Artifacts.toml file
artifacts_toml = joinpath(@__DIR__, "..", "Artifacts.toml")

# Extract all platforms
artifacts = Pkg.Artifacts.load_artifacts_toml(artifacts_toml; pkg_uuid=UUID("6e34b625-4abd-537c-b88f-471c36dfa7a0"))
platforms = [Pkg.Artifacts.unpack_platform(e, "Bzip2", artifacts_toml) for e in artifacts["Bzip2"]]

# Filter platforms based on what wrappers we've generated on-disk
platforms = filter(p -> isfile(joinpath(@__DIR__, "wrappers", triplet(p) * ".jl")), platforms)

# From the available options, choose the best platform
best_platform = select_platform(Dict(p => triplet(p) for p in platforms))

if best_platform === nothing
    error("Unable to load Bzip2; unsupported platform $(triplet(platform_key_abi()))")
end

# Load the appropriate wrapper
include(joinpath(@__DIR__, "wrappers", "$(best_platform).jl"))

end  # module Bzip2_jll
