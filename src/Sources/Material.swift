class Material {
    func scatter(rayIn : Ray, hit : HitRecord, attenuation : inout Color, scatteredRay : inout Ray) -> Bool {
        return false
    }
}

class Lambertian : Material {
    private let albedo : Color

    init(albedo : Color) {
        self.albedo = albedo
    }

    override func scatter(rayIn : Ray, hit : HitRecord, attenuation : inout Color, scatteredRay : inout Ray) -> Bool {
        var scatterDirection : Vector3 = hit.normal + Vector3.randomUnitVector()

        // Catch degenerate scatter direction
        if (scatterDirection.nearZero()) {
            scatterDirection = hit.normal
        }

        scatteredRay = Ray(origin: hit.point, direction: scatterDirection)
        attenuation = albedo;
        return true;
    }
}


class Metal : Material {
    private let albedo : Color
    private let fuzz : Float

    init(albedo : Color, fuzz : Float) {
        self.albedo = albedo
        self.fuzz = fuzz < 1 ? fuzz : 1
    }

    override func scatter(rayIn : Ray, hit : HitRecord, attenuation : inout Color, scatteredRay : inout Ray) -> Bool {
        var reflectedDirection = Vector3.reflect(v: rayIn.direction, n: hit.normal)
        reflectedDirection = Vector3.unitVector(v: reflectedDirection) + fuzz * Vector3.randomUnitVector() 
        scatteredRay = Ray(origin: hit.point, direction: reflectedDirection)
        attenuation = albedo
        return Vector3.dot(u: scatteredRay.direction, v: hit.normal) > 0
    }
}