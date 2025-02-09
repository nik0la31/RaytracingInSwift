struct Ray {
    var origin : Point3
    var direction : Vector3

    init(origin : Point3, direction : Vector3) {
        self.origin = origin
        self.direction = direction
    }

    func at(t : Float) -> Point3 {
        return origin + t * direction
    }
}
