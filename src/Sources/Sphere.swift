class Sphere : Hittable {
    private var center : Point3
    private var radius : Float
    private let material : Material

    init(center : Point3, radius : Float, material : Material) {
        self.center = center
        self.radius = max(0.0, radius)
        self.material = material
    } 

    func hit(ray : Ray, t: Interval, hit : inout HitRecord) -> Bool {
        let oc : Vector3 = center - ray.origin
        let a : Float = ray.direction.lengthSquared()
        let h : Float = Vector3.dot(u: ray.direction, v: oc)
        let c : Float = oc.lengthSquared() - radius * radius
        let discriminant = h * h - a * c

        if (discriminant < 0) {
            return false
        }

        let sqrtd = discriminant.squareRoot()

        // Find the nearest root that lies in the acceptable range.
        var root = (h - sqrtd) / a
        if (!t.surrounds(x: root)) {
            root = (h + sqrtd) / a
            if (!t.surrounds(x: root)) {
                return false
            }
        }

        hit.t = root
        hit.point = ray.at(t: hit.t)
        let outwardNormal = (hit.point - center) / radius
        hit.setFaceNormal(ray: ray, outwardNormal: outwardNormal)
        hit.material = material

        return true
    }
}
