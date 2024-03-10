# A3b code tests

using Test

include("A3b-code.jl")

@testset "movingavg" begin
    x = [1, 1, 1, 1]
    @test movingavg(x; λ=0.5) == [0.5, 0.75, 0.875, 0.9375]
end

@testset "filterIIR" begin
    # test first order
    x = [1, 1, 1]
    a1, b0, b1 = 1, 1, 1
    a = [a1]
    b = [b0, b1]
    y = filterIIR(x; a, b)
    @test y[1] == b0*x[1]
    @test y[2] == b0*x[2] + b1*x[1] - a1*y[1]
    @test y[3] == b0*x[3] + b1*x[2] - a1*y[2]

    # test second order
    x = [1, 1, 1, 1]
    a1, a2, b0, b1, b2 = 1, 1, 1, 1, 1
    a = [a1, a2]
    b = [b0, b1, b2]
    y = filterIIR(x; a, b)
    @test y[1] == b0*x[1]
    @test y[2] == b0*x[2] + b1*x[1] - a1*y[1]
    @test y[3] == b0*x[3] + b1*x[2] + b2*x[1] - (a1*y[2] + a2*y[1])
    @test y[4] == b0*x[4] + b1*x[3] + b2*x[2] - (a1*y[3] + a2*y[2])
end

@testset "convolve" begin
    @test convolve([1 2 3], [1]) == [1.0, 2.0, 3.0] # impulse
    @test convolve([1 2 3], [0 1]) == [0.0, 1.0, 2.0] # delay
    @test convolve([1 2 3], [0 1 0]; i0=2) == [1.0, 2.0, 3.0]

    x = [1 2 1 2 1 ]
    h = [0.5 1 0.5]
    @test convolve(x, h; i0=2) == [2.0, 3.0, 3.0, 3.0, 2.0]
end
