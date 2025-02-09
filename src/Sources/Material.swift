import Foundation // pow

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

class Dielectric : Material {
    // Refractive index in vacuum or air, or the ratio of the material's refractive index over
    // the refractive index of the enclosing media
    private let refractionIndex : Float

    init(refractionIndex : Float) {
        self.refractionIndex = refractionIndex
    }

    override func scatter(rayIn : Ray, hit : HitRecord, attenuation : inout Color, scatteredRay : inout Ray) -> Bool {
        attenuation = Color(x: 1.0, y: 1.0, z: 1.0)
        let ri : Float = hit.isFrontFace ? (1.0 / refractionIndex) : refractionIndex

        let unitDirection = Vector3.unitVector(v: rayIn.direction)
        let cosTheta : Float = min(Vector3.dot(u: -unitDirection, v: hit.normal), 1.0)
        let sinTheta : Float = (1.0 - cosTheta * cosTheta).squareRoot()

        let cannotRefract : Bool = ri * sinTheta > 1.0;
        var direction : Vector3

        if (cannotRefract || Dielectric.reflectance(cosine: cosTheta, refractionIndex: ri) > Raytracing.randomFloat()) {
            direction = Vector3.reflect(v: unitDirection, n: hit.normal)
        }
        else {
            direction = Vector3.refract(uv: unitDirection, n: hit.normal, etaiOverEtat: ri)
        }

        scatteredRay = Ray(origin: hit.point, direction: direction)
        return true;
    }

    static func reflectance(cosine : Float, refractionIndex : Float) -> Float {
        // Use Schlick's approximation for reflectance.
        var r0 : Float = (1 - refractionIndex) / (1 + refractionIndex)
        r0 = r0 * r0
        return r0 + (1-r0) * pow(1 - cosine, 5)
    }
}
