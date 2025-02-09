struct HitRecord {
    var point = Point3()
    var normal = Vector3()
    var material : Material? = nil
    var t : Float = 0
    var isFrontFace : Bool = true

    mutating func setFaceNormal(ray : Ray, outwardNormal : Vector3) {
        // Sets the hit record normal vector.
        // NOTE: the parameter `outward_normal` is assumed to have unit length.

        isFrontFace = Vector3.dot(u: ray.direction, v: outwardNormal) < 0
        normal = isFrontFace ? outwardNormal : -outwardNormal
    }
}

protocol Hittable {
    func hit(ray : Ray, t : Interval, hit : inout HitRecord) -> Bool
}
