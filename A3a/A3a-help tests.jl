using Test

include("A3a-code.jl")
include("../A1-Jupyter Notebooks/A1b-code.jl")

# Q1a,b - Plot outputs.

# Q2a delta and step functions.
# Note that the delta function should return 1 within a sample period centered on zero.

@testset "delta and step" begin
    @test δ(0; fs=1) == 1
    @test δ(1/3; fs=1) == 1
    @test δ(-1/3; fs=1) == 1
    @test δ(1; fs=1) == 0
    @test δ(-2/3; fs=1) == 0

    @test u(0) == 1
    @test u(1) == 1
    @test u(-1) == 0
end

@testset "energy, power, and snr" begin
    t = 0:0.01:1
    y = sinewave.(t)
    @test energy(y) ≈ 50.0 atol=0.001

    Ps = power(y)
    @test Ps ≈  0.4950 atol=0.001
    @test snr(Ps, Ps/10) == 10

    f = 100
    fs = 1000
    t = range(0, stop=0.05, step=1/fs)
    y = gammatone.(t; f, fs)
    @test energy(y) ≈ 0.9999 atol=0.001
    @test power(y) ≈ 0.0196 atol=0.001
    Ps = power(y[0.005 .<= t .<= 0.040])
    @test Ps ≈ 0.02761 atol=0.001
    @test snr(Ps, 0.01) ≈ 4.4118 atol=0.001
end

@testset "noisysignal" begin
    fs = 1
    t = 0:4
    y = noisysignal.(t, t -> δ(t; fs); τ=0, T=1, σ=0)
    @test y == [1.0, 0.0, 0.0, 0.0, 0.0]

    y = noisysignal.(t, t -> δ(t; fs); τ=2, T=1, σ=0)
    @test y == [0.0, 0.0, 1.0, 0.0, 0.0]

    y = noisysignal.(t, t -> u(t); τ=2, T=2, σ=0)
    @test y == [0.0, 0.0, 1.0, 1.0, 0.0]

    y = noisysignal.(t, t -> u(t); τ=0, T=length(y), σ=0)
    @test y == [1.0, 1.0, 1.0, 1.0, 1.0]

    fs=10
    t = 0 : 1/fs : 0.4
    y = noisysignal.(t, t -> δ(t; fs); τ=0, T=0.4, σ=0)
    @test y == [1.0, 0.0, 0.0, 0.0, 0.0]

    y = noisysignal.(t, t -> δ(t; fs); τ=0.1, T=0.1, σ=0)
    @test y == [0.0, 1.0, 0.0, 0.0, 0.0]

    y = noisysignal.(t, t -> u(t); τ=0.2, T=0.2, σ=0)
    @test y == [0.0, 0.0, 1.0, 1.0, 0.0]

    # note T is an upper bound
    y = noisysignal.(t, t -> u(t); τ=0, T=maximum(t), σ=0)
    @test y == [1.0, 1.0, 1.0, 1.0, 0.0]
end

@testset "extent" begin
    @test extent(1; θ=1) == 1:1
    y = [1:10; 10:-1:1]
    @test extent(y; θ=0.1) == 1:20 # Note θ is fraction of max abs val
    @test extent(y; θ=1.0) == 10:11

    y = sqrt.([1:100; 100:-1:1])
    @test extent(y; θ=1.0) == 100:101
end
