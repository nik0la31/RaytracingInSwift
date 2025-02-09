class HittableList : Hittable {
    var objects : [Hittable] = []
    
    init() {

    }

    init(object: Hittable) { 
        add(object: object)
    }

    func clear() {
        objects.removeAll()
    }

    func add(object : Hittable) {
        objects.append(object)
    }

    func hit(ray : Ray, t : Interval, hit : inout HitRecord) -> Bool {
        var tempHit = HitRecord()
        var hitAnything = false
        var closestSoFar = t.max

        for object in objects {
            if (object.hit(ray: ray, t: Interval(min: t.min, max: closestSoFar), hit: &tempHit)) {
                hitAnything = true
                closestSoFar = tempHit.t
                hit = tempHit
            }
        }

        return hitAnything
    }
}
