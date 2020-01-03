React = require('react')

BAD_COLORS = [2, 3, 6, 7, 18, 19, 22, 35, 38, 51, 55]
tinycolor = require("tinycolor2")

export default Balloon = (props) -> 
    id = props.id
    baseColor = props.baseColor
    if not baseColor?
        baseColor = 0
        for i in [0...id.length]
            baseColor = (baseColor * 37 + id.charCodeAt(i)) % 64
        baseColor = (baseColor * 37) % 64
    while baseColor in BAD_COLORS
        baseColor = (baseColor + 7) % 64

    hDiff = Math.floor((baseColor & 15) / 16 * 360)
    brightnessPart = (baseColor >> 4) & 3
    brightness = Math.floor((6 + brightnessPart) / 8 * 100)

    <img src="/balloon.svg" style={filter: "hue-rotate(#{hDiff}deg) brightness(#{brightness}%)"} width="24px"/>


