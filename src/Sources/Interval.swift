struct Interval {
    let min : Float
    let max : Float

    static let empty = Interval(min: +Raytracing.infinity, max: -Raytracing.infinity) 
    static let universe = Interval(min: -Raytracing.infinity, max: +Raytracing.infinity)

    init() {
        self.min = +Raytracing.infinity
        self.max = -Raytracing.infinity
    }

    init(min : Float, max : Float) {
        self.min = min
        self.max = max
    }

    func size() -> Float {
        return max - min
    }

    func contains(x: Float) -> Bool {
        return min <= x && x <= max
    }

    func surrounds(x: Float) -> Bool {
        return min < x && x < max
    }
}