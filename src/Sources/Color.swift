typealias Color = Vector3

func printColor(pixelColor : Color) {
    let r = pixelColor.x;
    let g = pixelColor.y;
    let b = pixelColor.z;

    // Translate the [0,1] component values to the byte range [0,255].
    let intensity = Interval(min: 0.000, max: 0.999)
    let rbyte = Int(255.999 * intensity.clamp(x: r))
    let gbyte = Int(255.999 * intensity.clamp(x: g))
    let bbyte = Int(255.999 * intensity.clamp(x: b))

    print(rbyte, gbyte, bbyte, separator: " ")
}
