class Sphere : Hittable {
    var center : Point3;
    var radius : Float;

    init(center : Point3, radius : Float) {
        self.center = center
        self.radius = max(0.0, radius)
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

        return true
    }
}
