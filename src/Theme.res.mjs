// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Common from "./Common.res.mjs";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import * as Color from "@texel/color";

function hsv(h, s, v) {
  return Color.RGBToHex(Color.convert([
                  h,
                  s,
                  v
                ], Color.OKHSV, Color.sRGB));
}

function hsl(h, s, l) {
  return Color.RGBToHex(Color.convert([
                  h,
                  s,
                  l
                ], Color.OKHSL, Color.sRGB));
}

function customMonthHue(monthInt, param) {
  switch (monthInt) {
    case 1 :
        return 210;
    case 3 :
        return 270;
    case 4 :
        return 120;
    case 6 :
        return 80;
    case 7 :
        return 40;
    case 5 :
    case 8 :
        return 240;
    case 9 :
        return 180;
    case 10 :
        return 60;
    case 11 :
        return 340;
    case 12 :
        return 150;
    default:
      return 0;
  }
}

function weekColor(weekInt) {
  var weekPercent = weekInt / 53;
  return hsv(weekPercent * 360, 1.0, 1.0);
}

function monthHue(monthInt) {
  return 360 / 12 * Math.imul(monthInt - 3 | 0, 5) % 360.0;
}

var monthColors = Core__Array.make(12, false).map(function (param, i) {
      return hsl(monthHue(i), 1.0, 0.55);
    });

var monthColorsDim = Core__Array.make(12, false).map(function (param, i) {
      return hsl(monthHue(i), 1.0, 0.8);
    });

function monthColor(monthInt) {
  if (monthInt === 0) {
    return "#000";
  } else {
    return monthColors[monthInt - 1 | 0];
  }
}

function monthDimColor(monthInt) {
  if (monthInt === 0) {
    return "#000";
  } else {
    return monthColorsDim[monthInt - 1 | 0];
  }
}

var Light = {
  monthColors: monthColors,
  monthColorsDim: monthColorsDim,
  monthColor: monthColor,
  monthDimColor: monthDimColor
};

var monthColors$1 = Core__Array.make(12, false).map(function (param, i) {
      return hsl(monthHue(i), 1.0, 0.7);
    });

var monthColorsDim$1 = Core__Array.make(12, false).map(function (param, i) {
      return hsl(monthHue(i), 1.0, 0.4);
    });

function monthColor$1(monthInt) {
  if (monthInt === 0) {
    return "#fff";
  } else {
    return monthColors$1[monthInt - 1 | 0];
  }
}

function monthDimColor$1(monthInt) {
  if (monthInt === 0) {
    return "#fff";
  } else {
    return monthColorsDim$1[monthInt - 1 | 0];
  }
}

var Dark = {
  monthColors: monthColors$1,
  monthColorsDim: monthColorsDim$1,
  monthColor: monthColor$1,
  monthDimColor: monthDimColor$1
};

function monthVar(month) {
  return "var(--m" + month.toString() + ")";
}

function monthDimVar(month) {
  return "var(--m" + month.toString() + "dim)";
}

function getTheme() {
  return Common.useLocalStorageListener("theme", "light");
}

function colorsByTheme(theme) {
  if (theme === "dark") {
    return [
            monthColor$1,
            monthDimColor$1
          ];
  } else {
    return [
            monthColor,
            monthDimColor
          ];
  }
}

function useTheme() {
  var match = Common.useLocalStorage("theme", "dark");
  var theme = match[0];
  React.useEffect((function () {
          var lights = Core__Array.make(13, false).map(function (param, i) {
                  return "--m" + i.toString() + ": " + monthColor(i) + "; --m" + i.toString() + "dim: " + monthDimColor(i) + ";";
                }).join("");
          var darks = Core__Array.make(13, false).map(function (param, i) {
                  return "--m" + i.toString() + ": " + monthColor$1(i) + "; --m" + i.toString() + "dim: " + monthDimColor$1(i) + ";";
                }).join("");
          var el = document.createElement("style");
          var innerHtml = "\n  html {\n   " + lights + "\n  }\n\n  .dark {\n  " + darks + "\n  }\n  ";
          el.innerText = innerHtml;
          console.log(el);
          document.head.appendChild(el);
        }), []);
  React.useEffect((function () {
          var match = theme === "dark" ? [
              "light",
              "dark",
              monthColor$1,
              monthDimColor$1
            ] : [
              "dark",
              "light",
              monthColor,
              monthDimColor
            ];
          document.documentElement.classList.remove(match[0]);
          document.documentElement.classList.add(match[1]);
        }), [theme]);
  return [
          theme,
          match[1]
        ];
}

export {
  hsv ,
  hsl ,
  customMonthHue ,
  weekColor ,
  monthHue ,
  Light ,
  Dark ,
  monthVar ,
  monthDimVar ,
  getTheme ,
  colorsByTheme ,
  useTheme ,
}
/* monthColors Not a pure module */
