typealias Color = Vector3

func printColor(pixelColor : Color) {
    let r = pixelColor.x;
    let g = pixelColor.y;
    let b = pixelColor.z;

    // Translate the [0,1] component values to the byte range [0,255].
    let rbyte = Int(255.999 * r);
    let gbyte = Int(255.999 * g);
    let bbyte = Int(255.999 * b);

    print(rbyte, gbyte, bbyte, separator: " ")
}
