type theme =
  | @as("dark") Dark
  | @as("light") Light

let hsv = (h, s, v) => Texel.convert((h, s, v), Texel.okhsv, Texel.srgb)->Texel.rgbToHex
let hsl = (h, s, l) => Texel.convert((h, s, l), Texel.okhsl, Texel.srgb)->Texel.rgbToHex

// let customMonthColor = monthInt => {
//   switch monthInt {
//   | 1 => hsv(260., 1.0, 1.0)
//   | 2 => hsv(0., 1.0, 1.0)
//   | 3 => hsv(140., 1.0, 1.0)
//   | 4 => hsv(100., 1.0, 1.0)
//   | 5 => hsv(100., 1.0, 1.0)
//   | 6 => hsv(100., 1.0, 1.0)
//   | 7 => hsv(100., 1.0, 1.0)
//   | 8 => hsv(100., 1.0, 1.0)
//   | 9 => hsv(90., 1.0, 1.0)
//   | 10 => hsv(50., 1.0, 1.0)
//   | 11 => hsv(50., 1.0, 0.5)
//   | 12 => hsv(150., 1.0, 0.5)
//   | _ => "#000"
//   }
// }

let customMonthHue = (monthInt, _) => {
  switch monthInt {
  | 1 => 210.
  | 2 => 0.
  | 3 => 270.
  | 4 => 120.
  | 5 => 240.
  | 6 => 80.
  | 7 => 40.
  | 8 => 240.
  | 9 => 180.
  | 10 => 60.
  | 11 => 340.
  | 12 => 150.
  | _ => 0.
  }
}

let weekColor = weekInt => {
  let weekPercent = weekInt->Int.toFloat /. 53.
  hsv(weekPercent *. 360., 1.0, 1.0)
}

// let monthHue = monthInt => {
//   let monthPercent = monthInt->Int.toFloat /. 12.

//   mod(monthInt, 2) == 0 ? Float.mod(monthPercent *. 360. +. 180., 360.) : monthPercent *. 360.
// }

// let monthHue = (monthInt, year) => {
//   let phi = 1.618034

//   Float.mod(360. /. phi *. (monthInt + year * 12)->Int.toFloat, 360.0)
// }

let monthHue = monthInt => {
  Float.mod(360. /. 12. *. ((monthInt - 3) * 5)->Int.toFloat, 360.0)
}

module Light = {
  let monthColors =
    Array.make(~length=12, false)->Array.mapWithIndex((_, i) => hsl(monthHue(i), 1.0, 0.55))
  let monthColorsDim =
    Array.make(~length=12, false)->Array.mapWithIndex((_, i) => hsl(monthHue(i), 1.0, 0.8))

  let monthColor = monthInt => {
    if monthInt == 0 {
      "#000"
    } else {
      monthColors->Array.getUnsafe(monthInt - 1)
    }
  }

  let monthDimColor = monthInt => {
    if monthInt == 0 {
      "#000"
    } else {
      monthColorsDim->Array.getUnsafe(monthInt - 1)
    }
  }
}

module Dark = {
  let monthColors =
    Array.make(~length=12, false)->Array.mapWithIndex((_, i) => hsl(monthHue(i), 1.0, 0.7))
  let monthColorsDim =
    Array.make(~length=12, false)->Array.mapWithIndex((_, i) => hsl(monthHue(i), 1.0, 0.4))

  let monthColor = monthInt => {
    if monthInt == 0 {
      "#fff"
    } else {
      monthColors->Array.getUnsafe(monthInt - 1)
    }
  }

  let monthDimColor = monthInt => {
    if monthInt == 0 {
      "#fff"
    } else {
      monthColorsDim->Array.getUnsafe(monthInt - 1)
    }
  }
}

let monthVar = month => {
  `var(--m${month->Int.toString})`
}

let monthDimVar = month => {
  `var(--m${month->Int.toString}dim)`
}

let getTheme = () => {
  Common.useLocalStorageListener("theme", "light")
}

let colorsByTheme = theme => {
  theme == "dark" ? (Dark.monthColor, Dark.monthDimColor) : (Light.monthColor, Light.monthDimColor)
}

let useTheme = () => {
  let (theme, setTheme) = Common.useLocalStorage("theme", Dark)

  React.useEffect1(() => {
    let (remove, add, c1, c2) =
      theme == Dark
        ? ("light", "dark", Dark.monthColor, Dark.monthDimColor)
        : ("dark", "light", Light.monthColor, Light.monthDimColor)

    Global.removeClassToHtmlElement(remove)
    Global.addClassToHtmlElement(add)

    for i in 0 to 12 {
      Global.setStyleProperty(`--m${i->Int.toString}`, c1(i))
      Global.setStyleProperty(`--m${i->Int.toString}dim`, c2(i))
    }

    None
  }, [theme])

  (theme, setTheme)
}
