class Vector3 : CustomStringConvertible {
    var x : Float
    var y : Float
    var z : Float

    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
    }

    init(x : Float, y : Float, z : Float) {
        self.x = x
        self.y = y
        self.z = z
    }

    static prefix func - (vec: Vector3) -> Vector3 {
        return Vector3(x: -vec.x, y: -vec.y, z: -vec.z)
    }

    static func += (left : inout Vector3, right: Vector3) {
        left.x += right.x
        left.y += right.y
        left.z += right.z
    }

    static func *= (vec : inout Vector3, t: Float) {
        vec.x *= t
        vec.y *= t
        vec.z *= t
    }

    static func /= (vec : inout Vector3, t: Float) {
        vec *= 1/t
    }

    static func + (u : Vector3, v  : Vector3) -> Vector3 {
        return Vector3(x: u.x + v.x, y: u.y + v.y, z: u.z + v.z)
    }

    static func - (u  : Vector3, v  : Vector3) -> Vector3 {
        return Vector3(x: u.x - v.x, y: u.y - v.y, z: u.z - v.z)
    }

    static func * (u  : Vector3, v : Vector3) -> Vector3 {
        return Vector3(x: u.x * v.x, y: u.y * v.y, z: u.z * v.z)
    }

    static func * (t : Float, v : Vector3) -> Vector3 {
        return Vector3(x: t * v.x, y: t * v.y, z: t * v.z)
    }

    static func * (v : Vector3, t : Float) -> Vector3 {
        return t * v
    }

    static func / (v : Vector3, t : Float) -> Vector3 {
        return (1/t) * v
    }

    static func dot(u : Vector3, v : Vector3) -> Float {
        return u.x * v.x + u.y * v.y + u.z * v.z
    }

    static func cross(u : Vector3, v : Vector3) -> Vector3 {
        return Vector3(
            x: u.y * v.z - u.z * v.y,
            y: u.z * v.x - u.x * v.z,
            z: u.x * v.y - u.y * v.x)
    }

    static func unitVector(v : Vector3) -> Vector3 {
        return v / v.length()
    }

    static func random() -> Vector3 {
        return Vector3(
            x: Raytracing.randomFloat(),
            y: Raytracing.randomFloat(),
            z: Raytracing.randomFloat())
    }

    static func random(min : Float, max : Float) -> Vector3 {
        return Vector3(
            x: Raytracing.randomFloat(min: min, max: max),
            y: Raytracing.randomFloat(min: min, max: max),
            z: Raytracing.randomFloat(min: min, max: max))
    }

    static func randomUnitVector() -> Vector3 {
        while (true) {
            let p = Vector3.random(min: -1, max: 1)
            let lensq = p.lengthSquared()
            if (1e-20 < lensq && lensq <= 1) {
                return p / lensq.squareRoot()
            }
        }
    }

    static func randomOnHemisphere(normal: Vector3) -> Vector3 {
        let onUnitSphere = randomUnitVector()
        if (Vector3.dot(u: onUnitSphere, v: normal) > 0.0) {
            // In the same hemisphere as the normal
            return onUnitSphere
        }
        else {
            return -onUnitSphere
        }
    }

    static func randomInUnitDisk() -> Vector3 {
        while (true) {
            let p = Vector3(
                x: Raytracing.randomFloat(min: -1, max: 1),
                y: Raytracing.randomFloat(min: -1, max: 1),
                z: 0);
            if (p.lengthSquared() < 1) {
                return p
            }
        }
    }

    static func reflect(v : Vector3, n: Vector3) -> Vector3 {
        return v - 2 * Vector3.dot(u: v, v: n) * n
    }

    static func refract(uv : Vector3, n : Vector3, etaiOverEtat : Float) -> Vector3 {
        let cosTheta : Float = min(dot(u: -uv, v: n), 1.0)
        let rOutPerp : Vector3 = etaiOverEtat * (uv + cosTheta * n)
        let rOutParallel : Vector3 = -abs(1.0 - rOutPerp.lengthSquared()).squareRoot() * n
        return rOutPerp + rOutParallel
    }

    func lengthSquared() -> Float {
        return x * x + y * y + z * z
    }

    func length() -> Float {
        return lengthSquared().squareRoot()
    }

    func nearZero() -> Bool {
        // Return true if the vector is close to zero in all dimensions.
        let s : Float = 1e-8;
        return (abs(x) < s) && (abs(y) < s) && (abs(z) < s)
    }

    public var description: String { return "\(x) \(y) \(z)" }
}

// Point3 is just an alias for Vector3, but useful for geometric clarity in the code.
typealias Point3 = Vector3
